import datetime
from BaseModel import BaseModel
from models import Util

class Category(BaseModel):    
    def __init__(self):
        self.name = None
        self.slug = None
        self.description = None
        self.added = datetime.datetime.now()

    def _presave(self, entitManager):
        self.slug = self.name.lower().replace(' ','-')


class Image(BaseModel):    
    def __init__(self):
        self.description = None
        self.filepath = None
        self.nicename = None
        self.isHomepagePic = False
        self.category = None
        self.added = datetime.datetime.now()


class Comment(BaseModel):    
    def __init__(self):
        self.imageId = None
        self.name = None
        self.comment = None
        self.added = datetime.datetime.now()
        
    def niceAdded(self):
        return Util.niceDate(self.added)


class EditableContent(BaseModel):    
    def __init__(self):
        self.content = None
        self.identifier = None
        self.added = datetime.datetime.now()
      


