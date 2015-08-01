from pymongo import MongoClient
import settings

conn = MongoClient(settings.DBHOST, settings.DBPORT)

_DBCON = eval('conn.'+ settings.DBNAME)


