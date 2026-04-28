use Googlepay;
select* from gpay1;

-- 1. what is the total amount Paid
select round(sum(amount_inr))as total_spent
from gpay1 
where Transaction_Type ='Paid';

-- 2.what is the total amount Received 

select round(sum(Amount_INR)) as TOTAL_RECEIVED 
FROM gpay1
where transaction_Type = 'Received';

-- 3.what is the Monthly Spending 
Select 
DATE_FORMAT(STR_to_DATE(Date, '%d %b %Y'), '%Y-%m') As Month,
SUM(Amount_INR) as Total_Spent
from gpay1
where Transaction_Type ='Paid'
group by DATE_FORMAT(STR_to_DATE(Date, '%d %b %Y'), '%Y-%m')
order by Month;


-- 4.Who is the Top 10 Payees
select Party_Name,sum(Amount_INR) as total,count(*) as txn_count
from gpay1
where Transaction_Type ='Paid'
group by Party_Name
order by Total Desc 
limit 10;


--  5.find out the Large Transactions
select * from gpay1
where Amount_INR > 10000
order by Amount_INR desc;

-- 6.what is the Amount received by bank
select Party_Name,sum(Amount_INR)
from gpay1
where Transaction_Type = 'Received' 
and Bank_Account = 'Kotak Mahindra Bank 0621'
group by Party_Name
order by Party_Name;

--  7.who is the Most frequent transaction Partner 
select Party_name,count(*) as transaction
from gpay1
group by Party_name
order by Transaction desc
limit 1;

-- 8.what is the Daily Spending 
SELECT 
    date,
    SUM(amount_inr) AS daily_spend
FROM gpay1
WHERE transaction_type = 'paid'
GROUP BY date
ORDER BY daily_spend desc;

-- 9.what is the bank wise spending 
select bank_account,
sum(amount_inr) as total_spent
from gpay1
where transaction_type = 'paid'
group by bank_account;

-- 10.spending split by bank account
select bank_account,transaction_type,
count(*) as txn,round(avg(amount_inr),2) as avg_amount
from gpay1
group by bank_account,transaction_type
order by bank_account,transaction_type

-- 11.what is the  total transaction count
select count(*) as Total_transaction
from gpay1;

-- 12. what is the moving average for the last 3 transaction

select date,amount_inr,
avg(amount_inr) over(
order by date
rows between 2 preceding and current row
) as moving_average
from gpay1

-- 13.top payee for every month
SELECT *
FROM (
    SELECT
        party_name,
        amount_inr,
        DATE_FORMAT(
            STR_TO_DATE(LOWER(TRIM(date)), '%e %b %Y'),
            '%Y-%m'
        ) AS month,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_FORMAT(
                STR_TO_DATE(LOWER(TRIM(date)), '%e %b %Y'),
                '%Y-%m'
            )
            ORDER BY amount_inr DESC
        ) AS rn
    FROM gpay1
    WHERE transaction_type = 'paid' 
) t
WHERE rn = 1;