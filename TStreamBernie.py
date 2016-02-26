import oauth2 as oauth
import urllib2 as urllib
import json

# See assignment1.html instructions or README for how to get these credentials

api_key = "qZpU3S59CB5fiOXxTXM9ZvRCK"
api_secret = "GmVIx3fbUzMQwmkS5fntWp2baj0nynI8sE2mEnZjED4pandATE"
access_token_key = "3974835413-vAm6Mmmcfx2RoTiIwgzNc5r7FMH1vQuvkOqIvKo"
access_token_secret = "LE7w5YT4tYdcYp6hPZsyUXE4J2iJNDM4IluhqXNSC5pwk"

_debug = 0

oauth_token    = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=api_key, secret=api_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"


http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

'''
Construct, sign, and open a twitter request
using the hard-coded credentials above.
'''
def twitterreq(url, method, parameters):
  req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url, 
                                             parameters=parameters)

  req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

  headers = req.to_header()

  if http_method == "POST":
    encoded_post_data = req.to_postdata()
  else:
    encoded_post_data = None
    url = req.to_url()

  opener = urllib.OpenerDirector()
  opener.add_handler(http_handler)
  opener.add_handler(https_handler)

  response = opener.open(url, encoded_post_data)

  return response

def fetchsamples():
  url = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=BernieSanders&count=3200"
  parameters = []
  response = twitterreq(url, "GET", parameters)
  ##print response
  for line in response:
    ##print 'whatwhat'
    print line.strip()

if __name__ == '__main__':
  fetchsamples()
