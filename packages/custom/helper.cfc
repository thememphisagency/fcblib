<cfcomponent displayname="Utility" hint="Package of helper functions">

<cfscript>
/**
 * Converts an array of structures to a CF Query Object.
 */
function arrayOfStructuresToQuery(theArray){
    var colNames = "";
    var theQuery = queryNew("");
    var i=0;
    var j=0;
    //if there's nothing in the array, return the empty query
    if(NOT arrayLen(theArray))
        return theQuery;
    //get the column names into an array =    
    colNames = structKeyArray(theArray[1]);
    //build the query based on the colNames
    theQuery = queryNew(arrayToList(colNames));
    //add the right number of rows to the query
    queryAddRow(theQuery, arrayLen(theArray));
    //for each element in the array, loop through the columns, populating the query
    for(i=1; i LTE arrayLen(theArray); i=i+1){
        for(j=1; j LTE arrayLen(colNames); j=j+1){
            querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
        }
    }
    return theQuery;
}

//Takes a selected column of data from a query and converts it into a list.
function queryColumnToList(qry, column) {
    var theList = "";
    var counter = "";
    var num_rows = arguments.qry.recordcount;
    var delim = ",";
    if(arrayLen(arguments) gte 3) delim = arguments[3];
    for (counter=1; counter lte num_rows; counter=counter+1) theList = listAppend(theList, arguments.qry[arguments.column][counter],delim);
    return theList;
}


// Takes a selected column of data from a query and converts it into an array
function queryColumnToArray(qry, column) {
    var arr = arrayNew(1);
    var ii = "";
    var loop_len = arguments.qry.recordcount;
    for (ii=1; ii lte loop_len; ii=ii+1) {
        arrayAppend(arr, arguments.qry[arguments.column][ii]);
    } 
    return arr;
}

function arrayOfStructsFind(Array, SearchKey, Value){
    var result = 0;
    var i = 1;
    var key = "";
    for (i=1;i lte arrayLen(array);i=i+1){
        for (key in array[i])
        {
            if(array[i][key]==Value and key == SearchKey){
                result = i;
                return result;
            }
        }
    }
    return result;
}

function queryToStructOfArrays(q){
    //a variable to hold the struct
    var st = structNew();
    //two variable for iterating
    var ii = 1;
    var cc = 1;
    //grab the columns into an array for easy looping
    var cols = listToArray(q.columnList);
    //iterate over the columns of the query and create the arrays of values
    for(ii = 1; ii lte arrayLen(cols); ii = ii + 1){
        //make the array with the col name as the key in the root struct
        st[cols[ii]] = arrayNew(1);
        //now loop for the recordcount of the query and insert the values
        for(cc = 1; cc lte q.recordcount; cc = cc + 1)
            arrayAppend(st[cols[ii]],q[cols[ii]][cc]);
    }
    //return the struct
    return st;
}

</cfscript>


<!------------------------
    --- NON script style Functions 

------------------------->




</cfcomponent>