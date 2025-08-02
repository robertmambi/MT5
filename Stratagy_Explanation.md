* # CheckMAConditions (UP, DOWN, UNDEFINED)

 - Check 4 MA(20,40,80,240) in same Period <br>
 - MAC = MA-Current
 - MAP = MA-Previous

    ## Validation <br>
    IF<br>  MAC20 > MAC40 > MAC80 > MAC240 <br>
    &&  MAC20 > MAP20 <br>
    &&  MAC40 > MAP40 <br>
    &&  MAC80 > MAP80 <br>
    &&  MAC240 > MAP240 <br>
    ==> (UP:UP)<br>
    <br>
    ELSE<br>
    MAC20 < MAC40 < MAC80 < MAC240<br>
    &&  MAC20 < MAP20<br>
    &&  MAC40 < MAP40 <br>
    &&  MAC80 < MAP80 <br>
    &&  MAC240 < MAP240 <br>
    ==> (DW:DOWN)<br>
    <br>
    ELSE<br>
    (XX:UNDEFINED)

![Diagram showing the CheckMAConditions logic flow](CheckMAConditions.png)