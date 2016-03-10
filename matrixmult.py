import MapReduce
import sys

"""
Word Count Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()



def mapper(record):
    # key: document identifier
    # value: document contents
    table = record[0]
    row_num = record[1]
    col_num = record[2]
    value = record[3]
    
    #print table + ',' + str(row_num) + ',' + str(col_num) + ',' + str(value)
    
    
    if table == 'a':
        mr.emit_intermediate((row_num, col_num), value)
    if table == 'b':
        mr.emit_intermediate((col_num, row_num),value)
    ##mydict[friend] = int(value)


def reducer(key, list_of_values):
    crossprodvalue = 1 
    
    for value in list_of_values:
        print value
        crossprodvalue = crossprodvalue * value
    crossprodrow = []
    crossprodrow.append(key)
    crossprodrow.append(crossprodvalue)
    mr.emit(crossprodrow)# value: list of occurrence counts
    

if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
