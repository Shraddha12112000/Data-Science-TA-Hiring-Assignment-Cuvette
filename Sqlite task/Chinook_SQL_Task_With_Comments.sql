
-- 1️⃣ Top 5 Customers by Total Purchase Amount
-- Get top 5 customers based on the total amount they have spent
SELECT
    c.FirstName || ' ' || c.LastName AS CustomerName,
    SUM(i.Total) AS TotalPurchase
FROM
    Customer c
JOIN
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY
    c.CustomerId
ORDER BY
    TotalPurchase DESC
LIMIT 5;

-- 2️⃣ Most Popular Genre by Total Tracks Sold
-- Find the most popular music genre by counting how many tracks have been sold
SELECT
    g.Name AS Genre,
    COUNT(il.Quantity) AS TotalTracksSold
FROM
    InvoiceLine il
JOIN
    Track t ON il.TrackId = t.TrackId
JOIN
    Genre g ON t.GenreId = g.GenreId
GROUP BY
    g.GenreId
ORDER BY
    TotalTracksSold DESC
LIMIT 1;

-- 3️⃣ Employees Who Are Managers Along With Their Subordinates
-- List all managers and the employees who report to them
SELECT
    m.EmployeeId AS ManagerID,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateID,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM
    Employee e
JOIN
    Employee m ON e.ReportsTo = m.EmployeeId;

-- 4️⃣ Most Sold Album Per Artist
-- For each artist, find the album that has sold the most tracks
SELECT
    a.Name AS ArtistName,
    al.Title AS AlbumTitle,
    COUNT(il.Quantity) AS TotalSold
FROM
    InvoiceLine il
JOIN
    Track t ON il.TrackId = t.TrackId
JOIN
    Album al ON t.AlbumId = al.AlbumId
JOIN
    Artist a ON al.ArtistId = a.ArtistId
GROUP BY
    al.AlbumId
HAVING
    TotalSold = (
        -- Subquery: get the maximum sold album count for each artist
        SELECT
            MAX(CountPerArtist.TotalSold)
        FROM (
            SELECT
                al2.ArtistId,
                COUNT(il2.Quantity) AS TotalSold
            FROM
                InvoiceLine il2
            JOIN
                Track t2 ON il2.TrackId = t2.TrackId
            JOIN
                Album al2 ON t2.AlbumId = al2.AlbumId
            GROUP BY
                al2.AlbumId
        ) AS CountPerArtist
        WHERE
            CountPerArtist.ArtistId = a.ArtistId
    );

-- 5️⃣ Monthly Sales Trends in 2013
-- Show monthly sales totals for the year 2013
SELECT
    STRFTIME('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Total), 2) AS MonthlySales
FROM
    Invoice
WHERE
    STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY
    Month
ORDER BY
    Month;
