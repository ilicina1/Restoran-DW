-- upit koji ispisuje sve zauzete stolove i id-jeve kupaca
SELECT t.table_number,c.customer_id
FROM table t,customer c
WHERE t.table_number=c.table_id;

-- upit koji ispisuje sve dostupne item-e i ime kategorije u koju spadaju
SELECT m.item_name,c.category_name
FROM menu m,category c
WHERE c.category_id=m.categories_category_id;

-- upit koji ispisuje narudzbe i ukupnu cijenu racuna za sve stolove
SELECT t.table_number,o.order_id,o.total_price
FROM table t,order o
WHERE t.table_number=o.table_number;

-- upit koji ispisuje broj stola i datum zauzeca
SELECT t.table_number,r.date
FROM table t,date d
WHERE t.table_number=r.table_id;