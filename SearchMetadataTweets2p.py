import sys
import json
import re

##For use with like URLS:  ""https://api.twitter.com/1.1/search/tweets.json?q=%23HashTag

def lines(fp):
    print str(len(fp.readlines()))

def main():
    #sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[1])
    ##countertwo = 0
    for line in tweet_file:
        
        tweets = json.loads(line)
        counter = 0
        geo = ' '
        coord = ' '
        id = ' '
        ctime = ' '
        text = ' '
        statuses = tweets['statuses']
        for tweet in statuses:
            #print s
            if 'text' in tweet:
                text = str(tweet['text'].encode("utf-8"))
                text = text.replace("|"," ")
                text = text.replace("\""," ")
                text = re.sub('[^ A-Za-z0-9]+','',text)
            ##text = ''.join(e for e in text if e.isalnum())
            ##text = ''.join(e for e in text if e.isalnum())
            ##text = ''.join(e for e in text if e.isalnum() | e == ' ')
            if 'id' in tweet:
                id = str(tweet['id']) 
            if 'created_at' in tweet:
                ctime = str(tweet['created_at'])
            if 'geo' in tweet:
                geo = str(tweet['geo'])
            if 'coordinates' in tweet:
                coord = str(tweet['coordinates'])
            print "\"" + id + "\"" + "|" + "\"" + text + "\"" + "|" + "\"" + ctime + "\"" + "|" + "\"" + coord + "\"" + "|" + "\"" + geo + "\""
            

                
                
                

                
            ##print counter
        ##countertwo = countertwo + 1
        ##print countertwo

    ##lines(tweet_file) 

if __name__ == '__main__':
    main()