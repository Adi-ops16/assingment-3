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