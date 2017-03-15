#encoding:utf8
__author__ = 'liangdong'
import urllib2
import sys,time,requests

headers = {'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
url="http://www.lvsetxt.com/books/0/581/"
for x in range(14321,14332):
    page=url +str(x)+".html"
    request=urllib2.Request(page,headers=headers)
    response=urllib2.urlopen(request).read()
    print page[-10:]
    with open(page[-10:].replace('.html','')+'.html','w') as f:
        f.write(response)
