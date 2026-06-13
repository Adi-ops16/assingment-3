CREATE TABLE Users (
    user_id serial PRIMARY KEY,
    full_name varchar(255) NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    role varchar(15) CHECK (role IN ('Ticket Manager', 'Football Fan')),
    phone_number varchar(14)
);

CREATE TABLE Matches (
    match_id serial PRIMARY KEY,
    fixture text,
    tournament_category text,
    base_ticket_price int CHECK (base_ticket_price >= 0),
    match_status varchar(20) CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);

CREATE TABLE Bookings (
    booking_id serial PRIMARY KEY,
    user_id int REFERENCES users (user_id),
    match_id int REFERENCES matches (match_id),
    seat_number varchar(10),
    payment_status varchar(20) CHECK (
        payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    ),
    total_cost int CHECK (total_cost >= 0)
);

-- Query-1
SELECT
    *
FROM
    matches
WHERE
    tournament_category = 'Champions League'
    AND match_status = 'Available'

-- Query-2
SELECT
    *
FROM
    users
WHERE
    full_name ILIKE 'Tanvir%'
    OR full_name ILIKE '%Haque%'

-- Query-3
SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM
    bookings
WHERE
    payment_status IS NULL;

-- Query-4
SELECT
    b.booking_id,
    b.total_cost,
    u.full_name,
    m.fixture
FROM
    bookings AS b
    JOIN matches AS m ON b.match_id = m.match_id
    JOIN users AS u ON b.user_id = u.user_id

-- Query-5
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM
    users AS u
    LEFT JOIN bookings AS b ON u.user_id = b.user_id
-- Query-6
SELECT
    booking_id,
    match_id,
    total_cost
FROM
    bookings
WHERE
    total_cost > (
        SELECT
            avg(total_cost)
        FROM
            bookings
    )
-- Query-7
SELECT
    *
FROM
    matches
ORDER BY
    base_ticket_price DESC
LIMIT
    2
OFFSET
    1