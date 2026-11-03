CREATE SCHEMA bookings;

CREATE TABLE bookings.aircrafts_data (
    aircraft_code character(3) NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    CONSTRAINT aircrafts_range_check CHECK ((range > 0))
);

CREATE TABLE bookings.airports_data (
    airport_code character(3) NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text NOT NULL
);

CREATE TABLE bookings.boarding_passes (
    ticket_no character(10) NOT NULL,
    flight_id integer NOT NULL,
    boarding_no integer NOT NULL,
    seat_no character varying(4) NOT NULL
);

CREATE TABLE bookings.bookings (
    book_ref character(6) NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL
);

CREATE TABLE bookings.flights (
    flight_id integer NOT NULL,
    flight_no character(6) NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    status character varying(20) NOT NULL,
    aircraft_code character(3) NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),
    CONSTRAINT flights_check1 CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY (ARRAY[('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text])))
);


CREATE TABLE bookings.seats (
    aircraft_code character(3) NOT NULL,
    seat_no character varying(4) NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    CONSTRAINT seats_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);

CREATE TABLE bookings.ticket_flights (
    ticket_no character(10) NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);

CREATE TABLE bookings.tickets (
    ticket_no character(13) NOT NULL,
    book_ref character(6) NOT NULL,
    passenger_id character varying(20) NOT NULL,
    passenger_name text NOT NULL,
    contact_data jsonb
);

ALTER TABLE ONLY bookings.flights ALTER COLUMN flight_id SET DEFAULT nextval('flights_flight_id_seq'::regclass);

INSERT INTO bookings.aircrafts_data (aircraft_code, model, range) VALUES
(320, '{"en": "Airbus A320-200", "ru": "Аэробус A320-200"}', 5700),
(321, '{"en": "Airbus A321-200", "ru": "Аэробус A321-200"}', 5600),
(319, '{"en": "Airbus A319-100", "ru": "Аэробус A319-100"}', 6700),
(733, '{"en": "Airbus A733-300", "ru": "Аэробус А733-300"}', 9000);


INSERT INTO bookings.airports_data (airport_code, airport_name, city, coordinates, timezone) values
('DME', '{"en": "Domodedovo Airport", "ru": "Домодедово"}', '{"en": "Moscow", "ru": "Москва"}',	'129.77099609375,62.0932998657226562', 'Europe/Moscow'),
('SVX', '{"en": "Kolcovo Airport", "ru": "Кольцово"}', '{"en": "Ekaterinburg", "ru": "Екатеринбург"}', '114.03900146484375,62.534698486328125',	'Asia/Yekaterinburg'),
('KZN', '{"en": "Kazan Airport", "ru": "Казань"}', '{"en": "Kazan", "ru": "Казань"}', '135.18800354004,48.5279998779300001', 'Asia/Kazan'),
('UUD', '{"en": "Baikal Airport", "ru": "Байкал"}', '{"en": "Ulan-Ude", "ru": "Улан-Удэ"}', '158.453994750976562,53.1679000854492188', 'Asia/Ulan-Udé'),
('UUS', '{"en": "Yuzhno-Sakhalinsk Airport", "ru": "Хомутово"}', '{"en": "Yuzhno-Sakhalinsk", "ru": "Южно-Сахалинск"}', '142.718002319335938,46.8886985778808594', 'Asia/Sakhalin'),
('VKO', '{"en": "Vnukovo Airport", "ru": "Внуково"}', '{"en": "Moscow", "ru": "Москва"}', '132.147994995117188,43.3989982604980469', 'Europe/Moscow'),
('IKT', '{"en": "Irkutsk Airport", "ru": "Иркутск"}', '{"en": "Irkutsk", "ru": "Иркутск"}', '30.2625007629394531,59.8003005981445312', 'Asia/Irkutsk'),
('SCW', '{"en": "Syktyvkar Airport", "ru": "Сыктывкар"}', '{"en": "Сыктывкар", "ru": "Сыктывкар"}', '73.4018020629882812,61.3437004089355469', 'Asia/Yekaterinburg'),
('BTK', '{"en": "Bratsk Airport", "ru": "Братск"}', '{"en": "Bratsk", "ru": "Братск"}', '86.1072006225585938,55.2700996398925781', 'Asia/Irkutsk');

INSERT INTO bookings.boarding_passes (ticket_no, flight_id, boarding_no, seat_no) VALUES
('5432159771', 1185, 1, '2A'),
('5435212352', 1185, 2, '2C'),
('5435212383', 1185, 3, '2D'),
('5435212334', 1185, 4, '6A'),
('5435212345', 1185, 5, '6B'),
('5435212356', 1185, 6, '6C'),
('5433367247', 11085, 7, '1A'),
('5433367228', 11085, 8, '1C'),
('5433367239', 11085, 9, '1D'),
('5433367220', 11085, 10, '6A'),
('5433367231', 11085, 11, '6B'),
('5433367252', 11085, 12, '6Z'),
('5435652273', 11847, 13, '1A'),
('5435652284', 11847, 14, '1C'),
('5435652285', 11847, 15, '1D'),
('5435652286', 11847, 16, '1F'),
('5435652297', 11847, 17, '11C'),
('5435652278', 11847, 18, '11D'),
('5435652289', 11847, 19, '11E'),
('5435652280', 11847, 20, '11F'),
('5435652291', 29440, 21, '12A'),
('5435652272', 29440, 22, '12B'),
('5433367253', 29440, 23, '1A'),
('5433367244', 29440, 24, '1C'),
('5433367255', 29440, 25, '1D'),
('5433367226', 29440, 26, '1F'),
('5433367257', 29440, 27, '2A'),
('5433367228', 29440, 28, '2C'),
('5435652280', 29440, 29, '8A');

INSERT INTO bookings.bookings (book_ref, book_date, total_amount) VALUES
('06B046', '2017-07-05 03:12:00+03', 265700.00),
('E170C3', '2017-08-15 14:27:00+03', 18100.00),
('F313DD', '2017-07-11 16:09:00+03', 89600.00),
('CCC5CB', '2017-07-10 05:31:00+03', 69600.00),
('1FB1E4', '2017-07-06 02:02:00+03', 109500.00),
('DE3EA6', '2017-08-12 10:13:00+03', 136200.00),
('4B75D1', '2017-07-30 00:24:00+03', 6000.00),
('9E60AA', '2017-07-17 05:39:00+03', 140100.00),
('69DAD1', '2017-07-28 09:00:00+03', 12000.00),
('08A2A5', '2017-07-15 10:54:00+03', 50700.00),
('C2CAB7', '2017-07-03 09:25:00+03', 28800.00),
('C6DA66', '2017-08-31 17:24:00+03', 140100.00),
('3EFFCA', '2017-08-16 13:15:00+03', 50700.00),
('7E0F14', '2017-08-22 11:13:00+03', 12000.00),
('63126E', '2017-07-27 05:04:00+03', 28800.00),
('285BC5', '2017-08-11 12:22:00+03', 109500.00),
('232788', '2017-07-02 05:41:00+03', 89600.00),
('C3B60B', '2017-08-08 21:41:00+03', 140100.00),
('7DC7C4', '2017-07-06 23:15:00+03', 69600.00),
('598886', '2017-07-22 01:15:00+03', 131800.00);


INSERT INTO bookings.flights (flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code, actual_departure, actual_arrival) VALUES
(1185, 'PG0134', '2017-09-10 09:50:00+03', '2017-09-10 14:55:00+03', 'DME', 'BTK', 'Scheduled', '319', NULL, NULL),
(11085, 'PG0569', '2017-08-24 15:05:00+03', '2017-08-24 16:10:00+03', 'SVX', 'SCW', 'Scheduled', '733', NULL, NULL),
(11847, 'PG0498', '2017-09-12 10:15:00+03', '2017-09-12 14:55:00+03', 'KZN', 'IKT', 'Scheduled', '321', NULL, NULL),
(29440, 'PG0065', '2017-09-02 12:15:00+03', '2017-09-02 18:05:00+03', 'UUD', 'VKO', 'Scheduled', '320', NULL, NULL);


INSERT INTO bookings.seats (aircraft_code, seat_no, fare_conditions) VALUES
('319', '2A', 'Business'),
('319', '2C', 'Business'),
('319', '2D', 'Business'),
('319', '6A', 'Economy'),
('319', '6B', 'Economy'),
('319', '6C', 'Economy'),
('320', '1A', 'Business'),
('320', '1C', 'Business'),
('320', '1D', 'Business'),
('320', '6A', 'Economy'),
('320', '6B', 'Economy'),
('320', '6C', 'Economy'),
('319', '1A', 'Business'),
('319', '1C', 'Business'),
('319', '1D', 'Business'),
('319', '1F', 'Business'),
('319', '11C', 'Economy'),
('319', '11D', 'Economy'),
('319', '11E', 'Economy'),
('319', '11F', 'Economy'),
('319', '12A', 'Economy'),
('319', '12B', 'Economy'),
('321', '1A', 'Business'),
('321', '1C', 'Business'),
('321', '1D', 'Business'),
('321', '1F', 'Business'),
('321', '2A', 'Business'),
('321', '2C', 'Business'),
('321', '8A', 'Economy'),
('321', '8B', 'Economy'),
('321', '8C', 'Economy');



INSERT INTO bookings.ticket_flights (ticket_no, flight_id, fare_conditions, amount) VALUES
('5432159771', 1185, 'Business', 42100.00),
('5435212352', 1185, 'Business', 42100.00),
('5435212383', 1185, 'Business', 42100.00),
('5435212334', 1185, 'Economy', 15400.00),
('5435212345', 1185, 'Economy', 15400.00),
('5435212356', 1185, 'Economy', 14000.00),
('5433367247', 11085, 'Business', 9800.00),
('5433367228', 11085, 'Business', 9800.00),
('5433367239', 11085, 'Business', 9800.00),
('5433367220', 11085, 'Economy', 3300.00),
('5433367231', 11085, 'Economy', 3300.00),
('5433367252', 11085, 'Economy', 3300.00),
('5435652273', 11847, 'Business', 50000.00),
('5435652284', 11847, 'Business', 50000.00),
('5435652285', 11847, 'Business', 50000.00),
('5435652286', 11847, 'Business', 50000.00),
('5435652297', 11847, 'Economy', 16700.00),
('5435652278', 11847, 'Economy', 16700.00),
('5435652289', 11847, 'Economy', 16700.00),
('5435652280', 11847, 'Economy', 16700.00),
('5435652291', 29440, 'Economy', 16700.00),
('5435652272', 29440, 'Economy', 16700.00),
('5433367253', 29440, 'Business', 50000.00),
('5433367244', 29440, 'Business', 50000.00),
('5433367255', 29440, 'Business', 50000.00),
('5433367226', 29440, 'Business', 50000.00),
('5433367257', 29440, 'Business', 50000.00),
('5433367228', 29440, 'Business', 50000.00),
('5435652280', 29440, 'Economy', 16700.00);


INSERT INTO bookings.tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data) VALUES
('5432159771', '06B046', 8, 'VALERIY TIKHONOV', '{"phone": "+70127117011"}'),
('5435212352', '06B046', 8, 'EVGENIYA ALEKSEEVA', '{"phone": "+70378089255"}'),
('5435212383', 'E170C3', 1, 'ARTUR GERASIMOV', '{"phone": "+70760429203"}'),
('5435212334', 'E170C3', 4, 'ALINA VOLKOVA', '{"email": "volkova.alina_03101973@postgrespro.ru", "phone": "+70582584031"}'),
('5435212345', 'F313DD', 6, 'MAKSIM ZHUKOV', '{"email": "m-zhukov061972@postgrespro.ru", "phone": "+70149562185"}'),
('5435212356', 'F313DD', 2, 'NIKOLAY EGOROV', '{"phone": "+70791452932"}'),
('5433367247', 'F313DD', 817, 'TATYANA KUZNECOVA', '{"email": "kuznecova-t-011961@postgrespro.ru", "phone": "+70400736223"}'),
('5433367228', 'CCC5CB', 2, 'IRINA ANTONOVA', '{"email": "antonova.irina04121972@postgrespro.ru", "phone": "+70844502960"}'),
('5433367239', 'CCC5CB', 3, 'VALENTINA KUZNECOVA', '{"email": "kuznecova.valentina10101976@postgrespro.ru", "phone": "+70268080457"}'),
('5433367220', '1FB1E4', 6, 'POLINA ZHURAVLEVA', '{"phone": "+70639918455"}'),
('5433367231', 'DE3EA6', 6, 'ALEKSANDR TIKHONOV', '{"phone": "+70568350272"}'),
('5433367252', '4B75D1', 8, 'ILYAPOPOV', '{"email": "popov_ilya.1971@postgrespro.ru", "phone": "+70003638926"}'),
('5435652273', '9E60AA', 764, 'ALEKSANDR KUZNECOV', '{"phone": "+70892601069"}'),
('5435652284', '69DAD1', 8, 'VSEVOLOD BORISOV', '{"email": "borisov_v_1975@postgrespro.ru", "phone": "+70126208679"}'),
('5435652285', '69DAD1', 6, 'NATALYA ROMANOVA', '{"email": "n-romanova.1981@postgrespro.ru", "phone": "+70898580864"}'),
('5435652286', '69DAD1', 7, 'ANTON BONDARENKO', '{"phone": "+70322899756"}'),
('5435652297', '08A2A5', 3, 'VALENTINA NIKITINA', '{"email": "nikitinavalentina.1975@postgrespro.ru", "phone": "+70794132478"}'),
('5435652278', '08A2A5', 8, 'ALLA TARASOVA', '{"phone": "+70212106431"}'),
('5435652289', 'C2CAB7', 1, 'OKSANA MOROZOVA', '{"phone": "+70806484401"}'),
('5435652280', 'C6DA66', 7, 'GENNADIY GERASIMOV', '{"email": "gerasimov.g111981@postgrespro.ru", "phone": "+70733090498"}'),
('5435652291', 'C6DA66', 4, 'RAISA KONOVALOVA', '{"phone": "+70038510644"}'),
('5435652272', '3EFFCA', 3, 'VIKTOR IVANOV', '{"email": "ivanovviktor1976@postgrespro.ru", "phone": "+70467287014"}'),
('5433367253', '7E0F14', 1, 'OKSANA KOROLEVA', '{"email": "okoroleva1963@postgrespro.ru", "phone": "+70512056517"}'),
('5433367244', '63126E', 7, 'NIKOLAY IVANOV', '{"email": "ivanovn1963@postgrespro.ru", "phone": "+70841199867"}'),
('5433367255', '285BC5', 1, 'DENIS KUZNECOV', '{"email": "kuznecov-d.1978@postgrespro.ru", "phone": "+70127715737"}'),
('5433367226', '232788', 5, 'ALEKSANDR DENISOV', '{"email": "adenisov1964@postgrespro.ru", "phone": "+70827988994"}'),
('5433367257', 'C3B60B', 7, 'YURIY MEDVEDEV', '{"phone": "+70620336121"}');



ALTER TABLE ONLY bookings.aircrafts_data
    ADD CONSTRAINT aircrafts_pkey PRIMARY KEY (aircraft_code);


ALTER TABLE ONLY bookings.airports_data
    ADD CONSTRAINT airports_data_pkey PRIMARY KEY (airport_code);


ALTER TABLE ONLY bookings.boarding_passes
    ADD CONSTRAINT boarding_passes_flight_id_boarding_no_key UNIQUE (flight_id, boarding_no);


ALTER TABLE ONLY bookings.boarding_passes
    ADD CONSTRAINT boarding_passes_flight_id_seat_no_key UNIQUE (flight_id, seat_no);


ALTER TABLE ONLY bookings.boarding_passes
    ADD CONSTRAINT boarding_passes_pkey PRIMARY KEY (ticket_no, flight_id);


ALTER TABLE ONLY bookings.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (book_ref);


ALTER TABLE ONLY bookings.flights
    ADD CONSTRAINT flights_flight_no_scheduled_departure_key UNIQUE (flight_no, scheduled_departure);


ALTER TABLE ONLY bookings.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);


ALTER TABLE ONLY bookings.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (aircraft_code, seat_no);


ALTER TABLE ONLY bookings.ticket_flights
    ADD CONSTRAINT ticket_flights_pkey PRIMARY KEY (ticket_no, flight_id);


ALTER TABLE ONLY bookings.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (ticket_no);


ALTER TABLE ONLY bookings.boarding_passes
    ADD CONSTRAINT boarding_passes_ticket_no_fkey FOREIGN KEY (ticket_no, flight_id) REFERENCES bookings.ticket_flights(ticket_no, flight_id);


ALTER TABLE ONLY bookings.flights
    ADD CONSTRAINT flights_aircraft_code_fkey FOREIGN KEY (aircraft_code) REFERENCES bookings.aircrafts_data(aircraft_code);


ALTER TABLE ONLY bookings.flights
    ADD CONSTRAINT flights_arrival_airport_fkey FOREIGN KEY (arrival_airport) REFERENCES bookings.airports_data(airport_code);


ALTER TABLE ONLY bookings.flights
    ADD CONSTRAINT flights_departure_airport_fkey FOREIGN KEY (departure_airport) REFERENCES bookings.airports_data(airport_code);


ALTER TABLE ONLY bookings.seats
    ADD CONSTRAINT seats_aircraft_code_fkey FOREIGN KEY (aircraft_code) REFERENCES bookings.aircrafts_data(aircraft_code) ON DELETE CASCADE;


ALTER TABLE ONLY bookings.ticket_flights
    ADD CONSTRAINT ticket_flights_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES bookings.flights(flight_id);


ALTER TABLE ONLY bookings.ticket_flights
    ADD CONSTRAINT ticket_flights_ticket_no_fkey FOREIGN KEY (ticket_no) REFERENCES bookings.tickets(ticket_no);


ALTER TABLE ONLY bookings.tickets
    ADD CONSTRAINT tickets_book_ref_fkey FOREIGN KEY (book_ref) REFERENCES bookings.bookings(book_ref);

