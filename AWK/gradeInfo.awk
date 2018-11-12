#!/usr/bin/awk -f
# Author: Kathleen Near

BEGIN {
    FS=",";                 #set field separator (in the .csv file all data is separated by commas)
    scoreRegex = "[0-9]+";  #match score to the regular expression of one or more numbers 0-9
    classSum = 0;
    
    ## Begin HTML ##
    printf("<html>\n");
    #include CSS border metadata in the head
    printf("\t<head>\n\t\t<style>\n\t\t\ttable { border: 1px solid black; }\n\t\t</style>\n\t</head>\n");
    #begin table with specified groups for formatting *"rules" not supported in HTML5*
    printf("\t<table style=\"width:100%\" rules=\"groups\">\n");
    #create groups for separator formatting
    printf("\t\t<colgroup>\n\t\t\t<col span=\"1\">\n\t\t</colgroup>\n");
    printf("\t\t<colgroup>\n\t\t\t<col span=\"5\">\n\t\t</colgroup>\n");
    printf("\t\t<colgroup>\n\t\t\t<col span=\"6\">\n\t\t</colgroup>\n");
    printf("\t\t<colgroup>\n\t\t\t<col span=\"1\">\n\t\t</colgroup>\n");
}
#first line:
NR == 1 {
    printf("\t\t<tbody>\n");                #begin label row (group for formatting)
    
    for(i = 2; i <= 6; i++) {               #column labels: "ID", "T1", "T2", ..., "T4"
        printf("\t\t\t<th>%s</th>\n", $i);
    }
    printf("\t\t\t<th>TAvg</th>\n");        #new column label for the test average
    for(j = 7; j <= 11; j++) {              #column labels: "Q1", "Q2", ..., "Q5"
        printf("\t\t\t<th>%s</th>\n", $j);
    }
    printf("\t\t\t<th>QAvg</th>\n");        #new column label for the quiz average
    printf("\t\t\t<th>Grade</th>\n");       #new column label for the student's overall grade
    
    printf("\t\t</tbody>\n");               #end label row
}
#for every line:
{
    sumTests = 0;
    sumQuizzes = 0;
    numTestEntries = 0;
    numQuizEntries = 0;
    
    ## Average Tests ##
    printf("\t\t<tr>\n\t\t\t<th>%d</th>\n", $2);    #begin new data row
    
    for(i = 3; i <= 6; i++) {                       #for test score columns T1-T4
        if (match($i, scoreRegex)) {                #if there is a test score, enter the score into the table & gather data for average
            printf("\t\t\t<th>%d</th>\n", $i);
            sumTests = sumTests + $i;
            numTestEntries++;
        }
        else
            printf("\t\t\t<th></th>\n");            #else enter an empty data entry
    }
    testAvg = sumTests/numTestEntries;
    printf("\t\t\t<th>%.0f</th>\n", testAvg);
    
    ## Average Quizzes ##
    for(j = 7; j <= 11; j++) {                      #for quiz score columns Q1-Q5
        if (match($j, scoreRegex)) {                #if there is a quiz score, enter the score into the table & gather data for average
            printf("\t\t\t<th>%d</th>\n", $j);
            sumQuizzes = sumQuizzes + $j;
            numQuizEntries++;
        }
        else
            printf("\t\t\t<th></th>\n");            #else enter an empty data entry
    }
    quizAvg = sumQuizzes/numQuizEntries;
    printf("\t\t\t<th>%.0f</th>\n", quizAvg);
    
    #student's overall grade
    studentAvg = (sumTests + (sumQuizzes * 10)) / (numTestEntries + numQuizEntries); #quizzes out of 10 points instead of 100
    printf("\t\t\t<th>%.0f</th>\n\t\t</tr>\n", studentAvg);
    #set up class sum for averaging
    classSum = classSum + studentAvg;
}
END {
    entryCount = NR - 1;    #number of entries (number of lines - 1)
    classAvg = classSum/entryCount;
    
    ## Class Average ##
    printf("\t\t<tbody>\n\t\t\t<th>classAvg</th>\n"); #begin class average row (group for formatting)
    for(i = 1; i <= 11; i++) {
            printf("\t\t\t<th></th>\n");            #insert empty entries until align with the Grade column
    }    
    printf("\t\t\t<th>%.0f</th>\n\t\t</tbody>\n", classAvg); #end class average row
    
    ## End HTML ##
    printf("\t</table>\n</html>");
}
