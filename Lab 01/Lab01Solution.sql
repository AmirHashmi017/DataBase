
--Task01: Set the status of students whose IDs are odd to zero
update user_details set status=0 where (user_id%2=1);


--Task02: Set the gender of students to male whose status is zero and female whose status is 1.
update user_details set gender=case
	when user_id%2=0 and status=1 then 'Male'
	when user_id%2<>0 and status=0 then 'Female'
END;

select * from user_details

