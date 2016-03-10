import MapReduce
import sys


mr = MapReduce.MapReduce()



def mapper(record):
    # key: document identifier
    # value: document contents
    personA = record[0]
    personB = record[1]
    
    
    mr.emit_intermediate(personA, personB)
    mr.emit_intermediate(personB,personA)
    ##mydict[friend] = int(value)


def reducer(friend, list_of_values):
    total = 0
    print 'list of values'
    print list_of_values
    for v in list_of_values:
        print 'v' + v
        print list_of_values.count(v)
        if list_of_values.count(v) < 2:
            output = friend, v 
            mr.emit(output)# value: list of occurrence counts
    

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
