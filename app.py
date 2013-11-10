import random
import json
import datetime
import os 
import bottle
import settings
from db import _DBCON
from Helpers import logger
from EntityManager import EntityManager
from Auth.auth import AuthService, User, AuthPlugin
from Auth.apps import auth_app
from models import Util
from models.Email import Email
from models.Models import *
from PIL import Image as PILImage
from BottlePlugins import ForceProtocolPlugin

public_urls = [
    '/',
    '/gallery/:slug',
    '/gallery/:slug/:imageId',
]

auth_plugin = AuthPlugin(EntityManager(), exclude_routes=public_urls)
force_http_plugin = ForceProtocolPlugin(protocol='http', environment=settings.ENVIRONMENT)

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
    return {
        'CACHEBREAKER':'1',
        'cats':EntityManager().find('Category', sort=[('name',1)])
    }

def commonViewDataAdmin():
    return {
        'CACHEBREAKER':'1',
        'user': EntityManager().find_one_by_id('User', bottle.request.session.user_id)
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
        cat = EntityManager().find_one_by_id('Category', bottle.request.POST.id)
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
        size = 150, 150
        im = PILImage.open(fullpath)
        im.thumbnail(size)
        im.save(fullpath.replace('/uploads/','/uploads/thumbs/'))
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
    i = EntityManager().find_one_by_id('Image', id)
    i.isHomepagePic = bool == '1'
    i.save()

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





#######################################################


app = bottle.app()
app.install(force_http_plugin)
app.install(auth_plugin)
#app.install(viewdata_plugin)

app.mount('/auth/', auth_app)


if __name__ == '__main__':
    with open(settings.ROOTPATH +'/app.pid','w') as f:
        f.write(str(os.getpid()))

    if settings.DEBUG: 
        bottle.debug() 
        
    bottle.run(app=app,server=settings.SERVER, reloader=settings.DEBUG, host=settings.APPHOST, port=settings.APPPORT, quiet=(settings.DEBUG==False) )
