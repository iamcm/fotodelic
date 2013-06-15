import random
import json
import datetime
import os 
import bottle
import settings
from db import _DBCON
from models import Util
from models.EntityManager import EntityManager
from models.User import User
from models.Session import Session
from models.Email import Email
from models import Logger
from models.Models import *
from PIL import Image as PILImage


def randomfilename():
   return str( random.randint(1000, 1000000) ) 

def checklogin(callback):
    def wrapper(*args, **kwargs):
        if bottle.request.get_cookie('token') or bottle.request.GET.get('token'):
            token = bottle.request.get_cookie('token') or bottle.request.GET.get('token')
            
            s = Session(_DBCON, publicId=token)
            if not s.valid or not s.check(bottle.request.get('REMOTE_ADDR'), bottle.request.get('HTTP_USER_AGENT')):
                #return bottle.HTTPError(403, 'Access denied')
                return bottle.redirect('/login')
                
            else:
                bottle.request.session = s
                return callback(*args, **kwargs)
        else:
            #return bottle.HTTPError(403, 'Access denied')
            return bottle.redirect('/login')

    return wrapper


def JSONResponse(callback):
    def wrapper(*args, **kwargs):
        bottle.response.content_type = 'text/json'
        return callback(*args, **kwargs)
    return wrapper


def ForceHTTP(callback):
    def wrapper(*args, **kwargs):
        if bottle.request.environ.get('wsgi.url_scheme') != 'http':
            return bottle.redirect(bottle.request.url.replace('https://','http://'))

        return callback(*args, **kwargs)
    return wrapper

def ForceHTTPS(callback):
    def wrapper(*args, **kwargs):
        if bottle.request.environ.get('wsgi.url_scheme') != 'https':
            return bottle.redirect(bottle.request.url.replace('http://','https://'))

        return callback(*args, **kwargs)
    return wrapper



# static files
if settings.PROVIDE_STATIC_FILES:
    @bottle.route('/static/<filepath:path>')
    def index(filepath):
        return bottle.static_file(filepath, root=settings.ROOTPATH +'/static/')




# auth
@bottle.route('/login', method='GET')
@ForceHTTPS
def index():
    viewdata = commonViewData()
    viewdata['cats'] = None

    return bottle.template('login', vd=viewdata)


@ForceHTTPS
@bottle.route('/login', method='POST')
def index():
    e = bottle.request.POST.get('email')
    p = bottle.request.POST.get('password')

    if e and p:
        u = User(_DBCON, email=e, password=p)

        if u._id and u.valid:
            s = Session(_DBCON)
            s.userId = u._id
            s.ip = bottle.request.get('REMOTE_ADDR')
            s.userAgent = bottle.request.get('HTTP_USER_AGENT')
            s.save()

            #hack to preserve set-cookie header with redirect (bottle.redirect strips this)
            resp = bottle.HTTPResponse("", status=302, Location='/admin')
            resp._cookies = bottle.response._cookies
            raise resp
            

    viewdata = commonViewData()
    viewdata['cats'] = None
    viewdata['error'] = 'Login failed'

    return bottle.template('login', vd=viewdata)


@bottle.route('/logout', method='GET')
@checklogin
def index():
    s = bottle.request.session
    s.destroy()
    
    return bottle.redirect('/login')






#######################################################
# Main app routes
#######################################################
def commonViewData():
    return {
        'CACHEBREAKER':'1',
        'cats':EntityManager(_DBCON).get_all(Category, sort_by=[('name',1)])
    }

def commonViewDataAdmin():
    return {
        'CACHEBREAKER':'1',
        'user':User(_DBCON, _id=bottle.request.session.userId)
    }


@bottle.route('/')
@ForceHTTP
def index():

    images = EntityManager(_DBCON).get_all(Image, filter_criteria={'isHomepagePic':True})
    text = EntityManager(_DBCON).get_all(HomePageContent)[0].content

    viewdata = commonViewData()
    viewdata.update({
            'images':images,
            'text':text,
        })

    return bottle.template('index', vd=viewdata)


@bottle.route('/gallery/:slug')
@ForceHTTP
def index(slug):
    cats = EntityManager(_DBCON).get_all(Category, filter_criteria={'slug':slug})

    if len(cats) > 0:
        cat = cats[0]
        images = EntityManager(_DBCON).get_all(Image, filter_criteria={'category._id':cat._id}, sort_by=[('added',1)])

        viewdata = commonViewData()
        viewdata.update({
                'images':images,
                'slug':slug,
            })

        return bottle.template('gallery', vd=viewdata)
    else:
        return bottle.HTTPError(404)


@bottle.route('/gallery/:slug/:imageId')
@ForceHTTP
def index(slug, imageId):
    cats = EntityManager(_DBCON).get_all(Category, filter_criteria={'slug':slug})

    if len(cats) == 0:
        return bottle.HTTPError(404)

    cat = cats[0]
    images = EntityManager(_DBCON).get_all(Image, filter_criteria={'category._id':cat._id}, sort_by=[('added',1)])

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

    comments = EntityManager(_DBCON).get_all(Comment, filter_criteria={'imageId':str(image._id)})

    viewdata = commonViewData()
    viewdata.update({
            'image':image,
            'slug':slug,
            'previous':previous,
            'next':next,
            'comments':comments or [],
        })

    return bottle.template('imagedetail', vd=viewdata)



@bottle.route('/gallery/:slug/:imageId/comment', method='POST')
@ForceHTTP
def index(slug, imageId):
    n = bottle.request.POST.get('name') or 'Anonymous'
    c = bottle.request.POST.get('comment')

    if n and c:
        com = Comment(_DBCON)
        com.name = n
        com.comment = c
        com.imageId = imageId
        com.save()


        e = Email()
        body = 'A comment has been added to fotodelic.co.uk:\n\r\n %s/gallery/%s/%s' % (bottle.request.environ['HTTP_HOST'], slug, imageId)
        e.send('Fotodelic - comment added', body)               

        return bottle.redirect(bottle.request.environ['HTTP_REFERER'])
    else:
        return bottle.HTTPError(404)




@bottle.route('/admin')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()

    return bottle.template('admin', vd=viewdata)



@bottle.route('/admin/category', method='GET')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()

    return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/category/:id/edit', method='GET')
@checklogin
@ForceHTTP
def index(id):
    viewdata = commonViewDataAdmin()
    viewdata['cat'] = Category(_DBCON, _id=id)

    return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/category/:id/delete', method='GET')
@checklogin
@ForceHTTP
def index(id):
    EntityManager(_DBCON).delete_one('Category', id)

    return bottle.redirect('/admin/categories')



@bottle.route('/admin/category', method='POST')
@checklogin
@ForceHTTP
def index():

    n = bottle.request.POST.name

    if n:
        cat = Category(_DBCON, _id=bottle.request.POST.id)
        cat.name = n
        cat.save()

        return bottle.redirect('/admin/categories')

    else:
        viewdata = commonViewDataAdmin()
        viewdata['error'] = 'Required data is missing'

        return bottle.template('admin_category', vd=viewdata)



@bottle.route('/admin/comment/:id/delete', method='GET')
@checklogin
@ForceHTTP
def index(id):
    EntityManager(_DBCON).delete_one('Comment', id)

    return bottle.redirect('/admin/comments')



@bottle.route('/admin/comments')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()
    viewdata['comments'] = EntityManager(_DBCON).get_all(Comment, sort_by=[('added',-1)])

    for c in viewdata['comments']:
        setattr(c, 'image', Image(_DBCON, _id=c.imageId))

    return bottle.template('admin_comments', vd=viewdata)



@bottle.route('/admin/homepage-text', method='GET')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()

    viewdata['content'] = EntityManager(_DBCON).get_all(HomePageContent)[0].content

    return bottle.template('homepagetext', vd=viewdata)



@bottle.route('/admin/homepage-text', method='POST')
@checklogin
@ForceHTTP
def index():
    homepagecontent = EntityManager(_DBCON).get_all(HomePageContent)[0]
    homepagecontent.content = bottle.request.POST.content
    homepagecontent.save()

    return bottle.redirect('/admin')



@bottle.route('/admin/image', method='GET')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()
    viewdata['cats'] = EntityManager(_DBCON).get_all(Category, sort_by=[('name',1)])

    return bottle.template('admin_image', vd=viewdata)



@bottle.route('/admin/image', method='POST')
@checklogin
@ForceHTTP
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

    i = Image(_DBCON)
    i.filepath = fullpath.split('/static/')[1]
    i.nicename = uploadedFile.filename
    i.category = Category(_DBCON, bottle.request.POST.get('catId'))
    i.save()



@bottle.route('/admin/images')
@checklogin
@ForceHTTP
def index():
    viewdata = commonViewDataAdmin()
    viewdata['cats'] = EntityManager(_DBCON).get_all(Category, sort_by=[('name',1)])

    filter_criteria = {}
    
    if bottle.request.GET.get('category') and bottle.request.GET.get('category') != 'all':
        filter_criteria = {'category.slug':bottle.request.GET.get('category')}

    images = EntityManager(_DBCON).get_all(Image, filter_criteria=filter_criteria, sort_by=[('added', -1)])

    for i in images:
        count = EntityManager(_DBCON).get_all(Comment, filter_criteria={'imageId':str(i._id)}, count=True)
        setattr(i, 'comment_count', count)

    if bottle.request.GET.get('order') and bottle.request.GET.get('order') == 'comments':
        images = sorted(images, key=lambda i: i.comment_count, reverse=True)

    viewdata['images'] = images

    return bottle.template('admin_images', vd=viewdata)



@bottle.route('/admin/image/:id/toggle-homepage/:bool')
@checklogin
@ForceHTTP
def index(id, bool):
    i = Image(_DBCON, _id=id)
    i.isHomepagePic = bool == '1'
    i.save()

    return '1'



@bottle.route('/admin/image/:id/delete')
@checklogin
@ForceHTTP
def index(id):
    i = Image(_DBCON, _id=id)

    path = os.path.join(settings.ROOTPATH, 'static', i.filepath)

    if os.path.isfile(path):
        os.remove(path)

        if os.path.isfile(path.replace('uploads/','uploads/thumbs/')):
            os.remove(path.replace('uploads/','uploads/thumbs/'))

    for c in EntityManager(_DBCON).get_all(Comment, filter_criteria={'imageId':str(i._id)}):
        EntityManager(_DBCON).delete_one('Comment', c._id)

    EntityManager(_DBCON).delete_one('Image', i._id)


    return bottle.redirect('/admin/images')





#######################################################

if __name__ == '__main__':
    with open(settings.ROOTPATH +'/app.pid','w') as f:
        f.write(str(os.getpid()))

    if settings.DEBUG: 
        bottle.debug() 
        
    bottle.run(server=settings.SERVER, reloader=settings.DEBUG, host=settings.APPHOST, port=settings.APPPORT, quiet=(settings.DEBUG==False) )
