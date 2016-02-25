import sys
import json



def lines(fp):
    print str(len(fp.readlines()))

def main():
    #sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[1])
    ##countertwo = 0
    for line in tweet_file:
        
        tweetsjs = json.loads(line)
        counter = 0
        for tweet in tweetsjs:
            counter = counter + 1
            text = str(tweet['text'].encode("utf-8"))
            text = text.replace("|"," ")
            text = text.replace("\""," ")
            id = str(tweet['id'])
            tweettime = str(tweet['created_at'])
            print "\"" + id + "\"" + "|" + "\"" + text + "\"" + "|" + "\"" + tweettime + "\""
       
                
                
                ##if key =='text':
                    ##print str(af)
                    ##print str(tweet['text'].encode("utf-8"))
                ##if key =='id':
                    ##print str(tweet['id'])
                ##if key =='created_at':
                    ##print str(tweet['created_at'])
                ##if key =='coordinates':
                    ##print 'coordinates ' + str(tweet['coordinates'])
                ##if key =='geo':
                    ##print 'geo ' + str(tweet['geo'])

                
            ##print counter
        ##countertwo = countertwo + 1
        ##print countertwo

    ##lines(tweet_file) 

if __name__ == '__main__':
    main()