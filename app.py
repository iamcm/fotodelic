# coding=utf8
import random
import json
import datetime
import os 
import bottle
import settings
from db import _DBCON
from Helpers import logger
from Helpers.emailHelper import Email
from mongorm.EntityManager import EntityManager
from Auth.auth import AuthService, User, AuthPlugin
from Auth.apps import auth_app
from models.Models import *
from BottlePlugins import ForceProtocolPlugin, SessionDataPlugin, ForceWWWPlugin
from Helpers import aes

public_urls = [
    '/',
    '/gallery/:slug',
    '/gallery/:slug/:imageId',
    '/checkout',
    '/checkout-send',
    '/checkout-complete',
    '/checkout-success',
    '/basket/add',
    '/basket/remove',
]

auth_plugin = AuthPlugin(EntityManager(), exclude_routes=public_urls)
force_http_plugin = ForceProtocolPlugin(protocol='http', environment=settings.ENVIRONMENT)
force_www_plugin = ForceWWWPlugin(environment=settings.ENVIRONMENT)
session_data_plugin = SessionDataPlugin(name='sc')


def randomfilename():
   return str( random.randint(1000, 1000000) ) 


#######################################################
# Static files
#######################################################
if settings.PROVIDE_STATIC_FILES:
    @bottle.route('/static/<filepath:path>', skip=True)
    def index(filepath):
        return bottle.static_file(filepath, root=settings.ROOTPATH +'/static/')




#######################################################
# Main app routes
#######################################################
def commonViewData():
    if hasattr(bottle.request, 'session_data') and bottle.request.session_data.has_key('basket'):
        basketcount = len(bottle.request.session_data['basket'])
    else:
        basketcount = 0
    return {
        'CACHEBREAKER':'1',
        'cats':EntityManager().find('Category', sort=[('name',1)]),
        'environment':settings.ENVIRONMENT,
        'basketcount':basketcount,
        'url':bottle.request.url,
    }

def commonViewDataAdmin():
    return {
        'CACHEBREAKER':'1',
        'user': EntityManager().find_one_by_id('User', bottle.request.session.user_id),
        'environment':settings.ENVIRONMENT,
    }


@bottle.route('/')
def index():

    images = EntityManager().find('Image', {'isHomepagePic':True})
    text = EntityManager().find('EditableContent', {'identifier':'homepage-content-box'})[0].content

    viewdata = commonViewData()
    viewdata.update({
            'images':images,
            'text':text,
        })

    bottle.response.set_cookie('sc',json.dumps({}))

    return bottle.template('index', vd=viewdata)


@bottle.route('/gallery/:slug')
def index(slug):
    cats = EntityManager().find('Category',{'slug':slug})

    if len(cats) > 0:
        cat = cats[0]
        images = EntityManager().find('Image', objfilter={'category._id':cat._id}, sort=[('added',1)])

        viewdata = commonViewData()
        viewdata.update({
                'images':images,
                'slug':slug,
                'category':cat,
            })

        return bottle.template('gallery', vd=viewdata)
    else:
        return bottle.HTTPError(404)


@bottle.route('/gallery/:slug/:imageId')
def index(slug, imageId):
    cats = EntityManager().find('Category', {'slug':slug})

    if len(cats) == 0:
        return bottle.HTTPError(404)

    cat = cats[0]
    images = EntityManager().find('Image', {'category._id':cat._id}, sort=[('added',1)])

    previous = None
    next = None
    image = None
    i = 0
    for im in images:
        if str(im._id) == imageId:
            image = im
            if i > 0:
                previous = images[i-1]._id

            if i < len(images)-1:
                next = images[i+1]._id

        i += 1


    if image == None:
        return bottle.HTTPError(404)

    viewdata = commonViewData()
    viewdata.update({
            'image':image,
            'slug':slug,
            'previous':previous,
            'next':next,
            'comments_url': settings.BASEURL + bottle.request.urlparts.path,
        })


    return bottle.template('imagedetail', vd=viewdata)



@bottle.route('/admin')
@bottle.route('/login')
def index():
    viewdata = commonViewDataAdmin()

    return bottle.template('admin', vd=viewdata)



@bottle.route('/admin/categories', method='GET')
def index():
    viewdata = commonViewDataAdmin()

    viewdata['cats'] = EntityManager().find('Category', sort=[('name',1)])

    return bottle.template('admin_categories', vd=viewdata)



@bottle.route('/admin/category', method='GET')
def index():
    viewdata = commonViewDataAdmin()

    return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/category/:id/edit', method='GET')
def index(id):
    viewdata = commonViewDataAdmin()
    viewdata['cat'] = EntityManager().find_one_by_id('Category', id)

    return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/category/:id/delete', method='GET')
def index(id):
    EntityManager().remove_one('Category', id)

    return bottle.redirect('/admin/categories')



@bottle.route('/admin/category', method='POST')
def index():

    n = bottle.request.POST.name
    d = bottle.request.POST.description

    if n:
        if bottle.request.POST.get('id'):
            cat = EntityManager().find_one_by_id('Category', bottle.request.POST.id)
        else:
            cat = Category()
        cat.name = n
        cat.description = d
        EntityManager().save('Category', cat)

        return bottle.redirect('/admin/categories')

    else:
        viewdata = commonViewDataAdmin()
        viewdata['error'] = 'Required data is missing'

        return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/homepage-text', method='GET')
def index():
    viewdata = commonViewDataAdmin()

    viewdata['content'] = EntityManager().find('EditableContent', {'identifier':'homepage-content-box'})[0].content

    return bottle.template('homepagetext', vd=viewdata)



@bottle.route('/admin/homepage-text', method='POST')
def index():
    homepagecontent = EntityManager().find('EditableContent', {'identifier':'homepage-content-box'})[0]
    homepagecontent.content = bottle.request.POST.content
    EntityManager().save('EditableContent', homepagecontent)

    return bottle.redirect('/admin')



@bottle.route('/admin/image', method='GET')
def index():
    viewdata = commonViewDataAdmin()
    viewdata['cats'] = EntityManager().find('Category', sort=[('name',1)])

    return bottle.template('admin_image', vd=viewdata)



@bottle.route('/admin/image', method='POST')
def index():
    uploadedFile = bottle.request.files.get('file')
    nicename, ext = os.path.splitext(uploadedFile.filename)

    savepath = os.path.join(settings.ROOTPATH, 'static', 'uploads')

    fullpath = os.path.join(savepath, randomfilename() + ext)
    while os.path.isfile(fullpath):
        fullpath = os.path.join(savepath, randomfilename() + ext)

    uploadedFile.save(fullpath)

    try:
        os.system('convert %s -resize 150 %s' % (fullpath, fullpath.replace('/uploads/','/uploads/thumbs/')))
    except:
        uploadedFile.save(fullpath.replace('/uploads/','/uploads/thumbs/'))

    i = Image()
    i.filepath = fullpath.split('/static/')[1]
    i.nicename = uploadedFile.filename
    i.category = EntityManager().find_one_by_id('Category', bottle.request.POST.get('catId'))
    EntityManager().save('Image', i)



@bottle.route('/admin/images')
def index():
    viewdata = commonViewDataAdmin()
    viewdata['cats'] = EntityManager().find('Category', sort=[('name',1)])

    filter_criteria = {}
    
    if bottle.request.GET.get('category') and bottle.request.GET.get('category') != 'all':
        if bottle.request.GET.get('category') == 'homepagepics':
            filter_criteria = {'isHomepagePic':True}
        else:
            filter_criteria = {'category.slug':bottle.request.GET.get('category')}

    images = EntityManager().find('Image', objfilter=filter_criteria, sort=[('added', -1)])

    viewdata['images'] = images

    return bottle.template('admin_images', vd=viewdata)



@bottle.route('/admin/image/:id/toggle-homepage/:bool')
def index(id, bool):
    em = EntityManager()
    i = em.find_one_by_id('Image', id)
    i.isHomepagePic = bool == '1'

    em.save('Image', i)

    return '1'



@bottle.route('/admin/image/:id/description', method='GET')
def index(id):
    viewdata = commonViewDataAdmin()

    i = EntityManager().find_one_by_id('Image', id)

    viewdata['image'] = i

    return bottle.template('admin_image_description', vd=viewdata)



@bottle.route('/admin/image/:id/description', method='POST')
def index(id):

    if bottle.request.POST.get('description'):
        i = EntityManager().find_one_by_id('Image', id)
        i.description = bottle.request.POST.get('description')
        EntityManager().save('Image', i)

    return bottle.redirect('/admin/images')



@bottle.route('/admin/image/:id/delete')
def index(id):
    i = EntityManager().find_one_by_id('Image', id)

    path = os.path.join(settings.ROOTPATH, 'static', i.filepath)

    if os.path.isfile(path):
        os.remove(path)

        if os.path.isfile(path.replace('uploads/','uploads/thumbs/')):
            os.remove(path.replace('uploads/','uploads/thumbs/'))

    EntityManager().remove_one('Image', i._id)


    return bottle.redirect('/admin/images')



@bottle.route('/basket/add', method='POST')
def index():
    id = bottle.request.POST.get('id')
    name = bottle.request.POST.get('name')
    returnTo = bottle.request.POST.get('returnTo')
    imagetype = bottle.request.POST.get('type')

    prices = {
        '6_4':'6',
        '7_5':'7',
        '9_6':'8',
        'full':'10',
        'sm':'3.50',
    }

    price = prices.get(imagetype, 10)

    basket = bottle.request.session_data.get('basket')
    if basket is None:
        basket = []

    already_exists = False
    for item in basket:
        if item['id'] == id:
            already_exists = True

    if not already_exists:
        basket.append({
            'id': id,
            'name': name,
            'price': price,
            })

    bottle.request.session_data['basket'] = basket
    bottle.response.add_header('Location', returnTo)
    bottle.response.status = 303

    return ''



@bottle.route('/basket/remove', method='POST')
def index():
    id = bottle.request.POST.get('id')
    returnTo = bottle.request.POST.get('returnTo')

    basket = bottle.request.session_data.get('basket')
    if basket:
        newbasket = []
        for item in basket:
            if item['id'] != id:
                newbasket.append(item)

        bottle.request.session_data['basket'] = newbasket

    bottle.response.add_header('Location', returnTo)
    bottle.response.status = 303

    return ''



@bottle.route('/checkout')
def index():
    basket = bottle.request.session_data.get('basket')
    if basket is None:
        basket = []

    viewdata = commonViewData()
    viewdata['basket'] = basket

    return bottle.template('checkout', vd=viewdata)



@bottle.route('/checkout-send', method='POST')
def index():
    basket = bottle.request.session_data.get('basket')
    if basket is None:
        return bottle.redirect('/')

    email = bottle.request.POST.get('email','')
    if email.strip() == '':
        return bottle.redirect('/checkout')

    b = Basket()
    b.session_id = bottle.request.session_data.get('_id')
    b.email = email

    items = []
    paypal_item_counter = 1
    for item in basket:
        if bottle.request.POST.get('quantity_'+ item['id']):
            o = OrderLine()
            o.item_id = item['id']
            o.title = item['name']
            o.quantity = bottle.request.POST.get('quantity_'+ item['id'])
            o.price = float(item['price']) * float(o.quantity)
            b.orderlines.append(o)

            items.append({
                'counter':str(paypal_item_counter),
                'name':o.title,
                'quantity':o.quantity,
                'cost':"%0.2f" % o.price,
                })

            paypal_item_counter += 1

    EntityManager().save('Basket', b)

    bottle.request.session_data['basket'] = []

    message = "<p>---User directed to PayPal---</p>"
    message += "<p></p>"
    message += "<p>Purchasing email: %s</p>" % email
    message += "<p></p>"

    for item in items:
        message += "<p>%s (Quantity %s) - &pound;%s</p>" % (item['name'], item['quantity'], item['cost'])

    message += "<p></p>"
    message += "<p><strong>IF</strong> the user completes payment there should be an 'Image purchased' email that follows this email that the will be generated when the user RETURNS to the site from PayPal - if this does not arrive then we need to check PayPal because the user may have completed payment and just closed the browser, in which case we need to send them the images but wont have had any confirmation of this!</p>"
    message += "<p></p>"
    message += "<p>Kind regards</p>"
    message += "<p>Fotodelic</p>"

    e = Email(sender=settings.EMAILSENDER, recipients=settings.DEVELOPERRECIPIENTS)
    e.send('Fotodelic potential purchase', message)

    return bottle.template('checkout_send', items=items)



@bottle.route('/checkout-complete', method=['GET','POST'])
def index():
    baskets = EntityManager().find('Basket', {'session_id':bottle.request.session_data['_id'], 'processed':False}, sort=[('added',-1)])
    if len(baskets) == 0:
        return "No basket found"

    basket = baskets[0]

    """
    Email the purchaser
    """
    message = "<p>Thank you for your purchase.</p>"
    message += "<p>These items will be emailed to you shortly:</p>"
    message += "<p></p>"

    for o in basket.orderlines:
        message += "<p>%s (Quantity %s)</p>" % (o.title, o.quantity)

    message += "<p></p>"
    message += "<p></p>"
    message += "<p>Kind regards</p>"
    message += "<p>Fotodelic</p>"

    e = Email(sender=settings.EMAILSENDER, recipients=[basket.email])
    e.send('Fotodelic purchase', message)

    debugmessage = message + "<p></p>"
    debugmessage += "<p>######################</p>"
    debugmessage += "<p>Would have gone to: %s</p>" % basket.email
    debugmessage += "<p>######################</p>"

    #copy to the site developer
    e = Email(sender=settings.EMAILSENDER, recipients=settings.DEVELOPERRECIPIENTS)
    e.send('Fotodelic purchase', debugmessage)

    """
    Email the site owner
    """
    siteemailmessage = "<p>---Image Purchased---</p>"
    siteemailmessage += "<p></p>"
    siteemailmessage += "<p>Purchasing email: %s</p>" % basket.email
    for o in basket.orderlines:
        siteemailmessage += "<p>Image: %s (Quantity %s)</p>" % (o.title, o.quantity)
    siteemailmessage += "<p></p>"
    siteemailmessage += "<p>Please check your PayPal account to ensure that the payment is 'complete'. If the payment is not complete please email the purchaser to reassure them that it is being processed. If the payment is complete please email the full quality image(s) to the purchaser</p>"
    siteemailmessage += "<p></p>"
    siteemailmessage += "<p></p>"
    siteemailmessage += "<p>Kind regards</p>"
    siteemailmessage += "<p>Fotodelic</p>"

    e = Email(sender=settings.EMAILSENDER, recipients=settings.EMAILRECIPIENTS)
    e.send('Fotodelic purchase', siteemailmessage)

    basket.processed = True
    EntityManager().save('Basket', basket)

    return bottle.redirect('/checkout-success')



@bottle.route('/checkout-success')
def index():
    viewdata = commonViewData()

    return bottle.template('checkout_success', vd=viewdata)




@bottle.error(500)
def index(*args):
    if len(args) > 0:
        err = args[0]

    output = err.traceback
    output += ' <hr /> '
    output += str(bottle.request.headers.__dict__)

    try:
        e = Email(sender=settings.EMAILSENDER, recipients=['i.am.chrismitchell@gmail.com'])
        e.send('Fotodelic 500 error', output)
    except:
        logger.log_exception()

    return '500 error occurred'


#######################################################


app = bottle.app()
app.install(force_http_plugin)
app.install(force_www_plugin)
app.install(auth_plugin)
app.install(session_data_plugin)
#app.install(viewdata_plugin)

app.mount('/auth/', auth_app)


if __name__ == '__main__':
    with open(settings.ROOTPATH +'/app.pid','w') as f:
        f.write(str(os.getpid()))

    if settings.DEBUG: 
        bottle.debug() 
        
    bottle.run(app=app,server=settings.SERVER, reloader=settings.DEBUG, host=settings.APPHOST, port=settings.APPPORT, quiet=(settings.DEBUG==False) )
