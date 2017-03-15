#encoding:utf8
__author__ = 'liangdong'
import urllib2,urllib
import sys,os,time,requests,re

headers = {'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
url="http://www.lvsetxt.com/books/0/581/"
for x in range(14321,14331):
    page=url +str(x)+".html"
    request=urllib2.Request(page,headers=headers)
    response=urllib2.urlopen(request).read()
    # print page[-10:]
    with open(page[-10:],'wb') as f:
        f.write(response)
    # urllib.urlretrieve(page,'d:/xiaoshuo')
# def saveHtml(htmlUrl):
#     # fileName=htmlUrl[htmlUrl.rfind("/")+1:]
#     path=r'c:/tmp'+'.html'
#     urlretrieve(page,path)
#
# if __name__=="__main__":
#     saveHtml()
