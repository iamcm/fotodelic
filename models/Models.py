import datetime
from dateutil import parser
from models.BaseModel import BaseModel
from models import Util

class Category(BaseModel):    
    def __init__(self, _DBCON, _id=None):
        self.fields = [
            ('name', None),
            ('slug', None),
            ('description', None),
            ('added', datetime.datetime.now()),
            ('oldId', None),            
        ]
        super(self.__class__, self).__init__(_DBCON, _id)
        
    def save(self):
        self.slug = self.name.replace(' ','-')
        BaseModel.save(self)


class Image(BaseModel):    
    def __init__(self, _DBCON, _id=None):
        self.fields = [
            ('description', None),
            ('filepath', None),
            ('nicename', None),
            ('isHomepagePic', False),
            ('category', None),
            ('added', datetime.datetime.now()),
            ('oldId', None),            
        ]
        super(self.__class__, self).__init__(_DBCON, _id)


class Comment(BaseModel):    
    def __init__(self, _DBCON, _id=None):
        self.fields = [
            ('imageId', None),
            ('name', None),
            ('comment', None),
            ('added', datetime.datetime.now()),
        ]
        super(self.__class__, self).__init__(_DBCON, _id)
        
    def niceAdded(self):
#        d = parser.parse(self.added)
 #       return Util.niceDate(d)
        return Util.niceDate(self.added)

class EditableContent(BaseModel):    
    def __init__(self, _DBCON, _id=None):
        self.fields = [
            ('content', None),
            ('identifier', None),
            ('added', datetime.datetime.now()),
        ]
        super(self.__class__, self).__init__(_DBCON, _id)
      


