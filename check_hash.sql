SELECT 
    UserName,
    CASE WHEN PasswordHash IS NULL THEN 'NULL' ELSE 'NOT NULL' END as IsNull,
    CASE WHEN PasswordHash = '' THEN 'EMPTY' ELSE 'HAS VALUE' END as IsEmpty,
    ISNULL(LEN(PasswordHash), 0) as HashLen,
    ISNULL(LEFT(PasswordHash, 10), 'N/A') as HashPrefix
FROM Users 
WHERE UserName='binhnguyen'
