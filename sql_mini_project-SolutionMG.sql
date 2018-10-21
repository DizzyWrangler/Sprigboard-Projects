/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name AS 'Facilities Charging Fee to Members' FROM country_club.Facilities WHERE membercost > 0

/* Query Response:

Facilities Charging Fee to Members
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court


*/
 


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name) AS 'Number of Facilities Free of Charge to Members' FROM country_club.Facilities WHERE membercost = 0 


/*   Query Response:

Number of Facilities Free of Charge to Members
                                             4
*/



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT  facid As 'FacID', 
        name AS 'Facility Name', 
        membercost AS 'Member Cost', 
        monthlymaintenance As 'Facility Monthly Maintenace Cost'
FROM country_club.Facilities 
WHERE membercost < monthlymaintenance * 0.2

/*   Query Response:


FacID  Facility Name   Member Cost  Facility Monthly Maintenace Cost
0      Tennis Court 1        5.0                                200
1      Tennis Court 2        5.0                                200
2      Badminton Court       0.0                                 50
3      Table Tennis          0.0                                 10
4      Massage Room 1        9.9                               3000
5      Massage Room 2        9.9                               3000
6      Squash Court          3.5                                 80
7      Snooker Table         0.0                                 15
8      Pool Table            0.0                                 15

*/



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM country_club.Facilities
WHERE facid IN (1, 5)
ORDER BY facid ASC

/* Query Response:

name             membercost   guestcost   facid  initialoutlay   monthlymaintenance
Tennis Court 2          5.0        25.0       1           8000                  200
Massage Room 2          9.9        80.0       5           4000                 3000

*/



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name AS  'Faciliate Name',  monthlymaintenance AS  'Facilities Monthly Maintenace Cost', 
CASE WHEN  monthlymaintenance <=100
THEN  'cheap'
ELSE  'expensive'
END AS Label
FROM country_club.Facilities

/* Query Response

Faciliate Name    Facilities Monthly Maintenace Cost   Label
Tennis Court 1                                   200   expensive
Tennis Court 2                                   200   expensive
Badminton Court                                   50   cheap
Table Tennis                                      10   cheap
Massage Room 1                                  3000   expensive
Massage Room 2                                  3000   expensive
Squash Court                                      80   cheap
Snooker Table                                     15   cheap
Pool Table                                        15   cheap

*/



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* last members */
SELECT firstname, surname, joindate
FROM country_club.Members
ORDER BY joindate DESC

/* Query Response:

firstname   surname            joindate
Darren      Smith              2012-09-26 18:08:45
Erica       Crumpet            2012-09-22 08:36:38
John        Hunt               2012-09-19 11:32:45
Hyacinth    Tupperware         2012-09-18 19:32:05
Millicent   Purview            2012-09-18 19:04:01
Henry       Worthington-Smyth  2012-09-17 12:27:15
David       Farrell            2012-09-15 08:22:05
Henrietta   Rumney             2012-09-05 08:42:35
Douglas     Jones              2012-09-02 18:43:05
Ramnaresh   Sarwin             2012-09-01 08:44:42
...

*/

/* last member */
SELECT  firstname, surname, joindate
FROM country_club.Members
WHERE joindate = (SELECT MAX(joindate) FROM country_club.Members)

/* Query Response:

firstname   surname    joindate
Darren      Smith      2012-09-26 18:08:45

*/



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT concat(mem.surname, ', ', mem.firstname) As Member_Name, fac.name AS Facility_Name
FROM country_club.Members mem
INNER JOIN country_club.Bookings book
ON mem.memid = book.memid
INNER JOIN country_club.Facilities fac
ON book.facid = fac.facid
WHERE fac.facid IN (0,1)
GROUP BY Member_Name


/* Query Response:

Member_Name         Facility_Name
Bader, Florence     Tennis Court 2
Baker, Anne         Tennis Court 1
Baker, Timothy      Tennis Court 2
Boothe, Tim         Tennis Court 2
Butters, Gerald     Tennis Court 1
Coplin, Joan        Tennis Court 1
Crumpet, Erica      Tennis Court 1
Dare, Nancy         Tennis Court 2
Farrell, David      Tennis Court 1
Farrell, Jemima     Tennis Court 2
Genting, Matthew    Tennis Court 1
GUEST, GUEST        Tennis Court 2
Hunt, John          Tennis Court 1
Jones, David        Tennis Court 2
Jones, Douglas      Tennis Court 1
Joplette, Janice    Tennis Court 1
Owen, Charles       Tennis Court 1
Pinker, David       Tennis Court 1
Purview, Millicent  Tennis Court 2
Rownam, Tim         Tennis Court 2
Rumney, Henrietta   Tennis Court 2
Sarwin, Ramnaresh   Tennis Court 2
Smith, Darren       Tennis Court 2
Smith, Jack         Tennis Court 1
Smith, Tracy        Tennis Court 1
Stibbons, Ponder    Tennis Court 2
Tracy, Burton       Tennis Court 2

*/



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */



/* Guest cost (memid = 0) using facilities on 2012-09-14 . Guest cost calculated as #of slots x guest cost per slot. */
SELECT  CONCAT(mem.surname,  ', ', mem.firstname) AS Member_Name, 
        fac.name AS Facility_Name, 
        fac.guestcost * book.slots AS Cost
FROM country_club.Bookings book
INNER JOIN country_club.Facilities fac ON book.facid = fac.facid
INNER JOIN country_club.Members mem ON mem.memid = book.memid
WHERE LEFT(book.starttime, 10) =  '2012-09-14' AND mem.memid = 0

UNION   /* join or union of Guest and Member cost info */

/* Member (memid !=0) cost using facilities on 2012-09-14 */
SELECT  CONCAT(mem.surname,  ', ', 
        mem.firstname) AS Member_Name, 
        fac.name AS Facility_Name, 
        fac.membercost AS Cost
FROM country_club.Bookings book
INNER JOIN country_club.Facilities fac ON book.facid = fac.facid
INNER JOIN country_club.Members mem ON mem.memid = book.memid
WHERE LEFT(book.starttime, 10) =  '2012-09-14' AND mem.memid != 0
/* Group by Member ID */
GROUP BY mem.memid

/* Order by descending member cost > 30 */
HAVING Cost > 30
ORDER BY Cost DESC


/* Query response:

Member_Name      Facility_Name    Cost Descending
GUEST, GUEST     Massage Room 2             320.0
GUEST, GUEST     Massage Room 1             160.0
GUEST, GUEST     Tennis Court 2             150.0
GUEST, GUEST     Tennis Court 2              75.0
GUEST, GUEST     Tennis Court 1              75.0
GUEST, GUEST     Squash Court                70.0
GUEST, GUEST     Squash Court                35.0

*/



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT Subquery.Member_Name, Subquery.Facility_Name, Subquery.Cost
FROM (
        SELECT  CONCAT(mem.surname,  ', ', mem.firstname) AS Member_Name, 
                fac.name AS Facility_Name,
                fac.guestcost * book.slots AS Cost
        FROM country_club.Bookings book
        INNER JOIN country_club.Facilities fac ON book.facid = fac.facid
        INNER JOIN country_club.Members mem ON mem.memid = book.memid
        WHERE LEFT(book.starttime, 10) =  '2012-09-14' AND mem.memid = 0

        UNION

        SELECT CONCAT(mem.surname,  ', ', mem.firstname) AS Member_Name, 
               fac.name AS Facility_Name,
               fac.membercost AS Cost
        FROM country_club.Bookings book
        INNER JOIN country_club.Facilities fac ON book.facid = fac.facid
        INNER JOIN country_club.Members mem ON mem.memid = book.memid
        WHERE LEFT(book.starttime, 10) =  '2012-09-14' AND mem.memid != 0
        /* Group by Member ID */
        GROUP BY mem.memid
         ) Subquery

/* Order by descending member cost > 30 */
HAVING Cost >30
ORDER BY Cost DESC


/* Query Response:

Member_Name      Facility_Name    Cost Descending
GUEST, GUEST     Massage Room 2             320.0
GUEST, GUEST     Massage Room 1             160.0
GUEST, GUEST     Tennis Court 2             150.0
GUEST, GUEST     Tennis Court 2              75.0
GUEST, GUEST     Tennis Court 1              75.0
GUEST, GUEST     Squash Court                70.0
GUEST, GUEST     Squash Court                35.0

*/



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT  fac.name AS Facility_Name, 
        SUM(CASE WHEN book.memid = 0 THEN fac.guestcost * book.slots ELSE fac.membercost END) AS Booking_Revenue
FROM country_club.Facilities fac
JOIN country_club.Bookings book ON fac.facid = book.facid
GROUP BY fac.name
HAVING Booking_Revenue < 1000
ORDER BY Booking_Revenue DESC

/* Query Response:

Facility_Name     Booking_Revenue
Pool Table                  270.0
Snooker Table               240.0
Table Tennis                180.0

*/




