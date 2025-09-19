use mydata;
select * from heart;
# Q(1): Genderwise Number of Patients who had Heart attack
select Gender,count(*) as No_of_Patients from heart where Heart_Attack_History="Yes" group by Gender;
# Q(2): Total no.of heart attack cases reported
select count(*) as Total_cases from heart where Heart_Attack_History="Yes";
# Q(3): Average cholestrol level of patients
select avg(Cholesterol_Level) as avg_cholestrol from heart;
# Q(4): Patient with high cholestrol level
select * from heart order by Cholesterol_Level desc limit 1;
# Q(5): Average LDL level of heart attack patients
select avg(LDL_Level) as avg_LDL from heart where Heart_Attack_History="Yes";
# Q(6): Patients with high stress levels
select * from heart order by Stress_Level desc limit 3;
# Q(7): No.of Patients with poor diet quality
select count(*) as Poor_diet from heart where Diet_Quality="Poor";
# Q(8): Genderwise count of Patients who smoke and also alcohol addicted 
select Gender,count(*) as No_of_patients from heart where Smoking_Status="yes" and Alcohol_Intake="High" group by Gender;
# Q(9): No.of Patients with a family history of heart disease
select count(*) as No_of_patients from heart where Family_History_Heart_Disease="Yes";
# Q(10): No.of Patients intaking medication 
select count(*) as Intaking_medication from heart where Medication_Usage="Yes";
# Q(11): Physically Inactive patients based on Gender
select Gender,count(*) as Physically_Inactive from heart where Physical_Activity="Sedentary" group by Gender;
# Q(12): Patient with low HDL level
select * from heart order by HDL_Level desc limit 1;
# Q(13): No.of patients grouped by physical activity level
select Physical_Activity,count(*) as patient_count from heart group by Physical_Activity;
# Q(14): No.of patients based on medication usage
select Medication_Usage,count(*) as patient_count from heart group by Medication_Usage;
# Q(15): Heart attack cases grouped by family history of heart disease
select Family_History_Heart_Disease,count(*) as heart_attack_count from heart where Heart_Attack_History="Yes" group by Family_History_Heart_Disease;
# Q(16): No.of patients based on LDL cholestrol level
select
	case
		when LDL_Level<100 then "Low"
        when LDL_Level between 100 and 160 then "Moderate"
        else "High"
	end as LDL_Status,
    count(*) as patient_count from heart group by LDL_Status;
# Q(17): No.of Patients based on gender and diabetes status
select Gender,Diabetes_Status,count(*) as patient_count from heart group by gender,Diabetes_Status;
# Q(18): No.of patients based on diet quality
select Diet_Quality,count(*) as patient_count from heart group by Diet_Quality;
# Q(19): No.of Heart attack cases based on Obesity Index
select
	case
		when Obesity_Index<20 then "Under weight"
        when Obesity_Index between 20 and 30 then "Normal weight"
        when Obesity_Index>30 then "Over weight"
        else "Nill"
	end as Obesity_status,
    count(*) as heart_attack_count from heart where Heart_Attack_History="Yes" group by Obesity_status;
# Q(20): No.of patients Grouped by Stress level
select Stress_Level,count(*) as No_of_patients from heart group by Stress_Level;
# Q(21): Patients with higher cholesterol than average cholesterol
select Cholesterol_Level,count(*) as count from heart where Cholesterol_Level>(select avg(Cholesterol_Level) from heart) group by Cholesterol_Level ;

# PROCEDURE 1(IN):
delimiter //
create procedure Heart_attack_gender(IN Patient_Gender VARCHAR(10))
BEGIN
	SELECT COUNT(*) AS Heart_attack_count from heart where Heart_Attack_History="Yes" and Gender=Patient_Gender;
END //
DELIMITER ;

call Heart_attack_gender("Male");
call Heart_attack_gender("Female");
# Takes IN parameter patient_gender to gender
# Returns the count of heart attack cases for the given gender

# PROCEDURE 2(IN):
DELIMITER //
CREATE PROCEDURE heart_attack_diabetes( OUT Diabetes_Condition VARCHAR(25))
BEGIN
	SELECT COUNT(*) AS Heart_attack_count from heart where Heart_Attack_History="Yes" and Diabetes_Status=Diabetes_Condition;
END //
DELIMITER ;

call heart_attack_diabetes("Yes");
call heart_attack_diabetes("No");

# Takes IN parameter Diabetes_Condition by Diabetes Status.
# Returns the count of heart attack cases where patients have or don't have Diabetes based on the input.

# PROCEDURE (OUT):
DELIMITER //
CREATE PROCEDURE high_cstl_patients(OUT cholesterol_count INT)
BEGIN
	SELECT COUNT(*) INTO cholesterol_count from heart where Cholesterol_Level>200;
END //
DELIMITER ;

call high_cstl_patients(@C);
select @C as High_cstl_count;

# Uses an out parameter(cholesterol_count) to store the count.
# Returns the total no.of patients with high cholestrol (>200).

# TRIGGER (BEFORE TRIGGER):
DELIMITER //
CREATE TRIGGER before_stress BEFORE INSERT ON heart for each row 
BEGIN
	IF NEW.Stress_Level NOT IN ('Low','Medium','High') THEN 
    SET NEW.Stress_Level="Unknown";
    END IF;
END //
DELIMITER ;
insert into heart(Patient_ID,Stress_Level) values(675,"Extreme");
select Patient_ID,Stress_Level from heart where Patient_ID=675;

# Prevents Invalid stress values from being Inserted.
# Assigns "Unknown" for cases where Stress level is missing or Incorrect.
