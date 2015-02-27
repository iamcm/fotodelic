import datetime
from mongorm.BaseModel import BaseModel
from models import Util

class Category(BaseModel):    
    def __init__(self):
        self.name = None
        self.slug = None
        self.description = None
        self.payment_scheme_id = None
        self.added = datetime.datetime.now()

    def _presave(self, entityManager):
        self.slug = self.name.lower().replace(' ','-')


class Image(BaseModel):    
    def __init__(self):
        self.description = None
        self.filepath = None
        self.nicename = None
        self.isHomepagePic = False
        self.category = None
        self.added = datetime.datetime.now()


class EditableContent(BaseModel):    
    def __init__(self):
        self.content = None
        self.identifier = None
        self.added = datetime.datetime.now()
      
      
class Basket(BaseModel):
    def __init__(self):
        self.orderlines = []
        self.session_id = None
        self.email = None
        self.processed = False
        self.added = datetime.datetime.now()


class OrderLine(BaseModel):
    def __init__(self):
        self.item_id = None
        self.title = None
        self.quantity = 1
        self.price = None
        self.added = datetime.datetime.now()


class PaymentScheme(BaseModel):
    def __init__(self):
        self.name = None
        self.added = datetime.datetime.now()


class PaymentOption(BaseModel):
    def __init__(self):
        self.scheme_id = None
        self.name = None
        self.price = None
        self.added = datetime.datetime.now()

