-- Seed Suppliers
INSERT INTO suppliers (supplier_code, name, contact_person, email, phone, address, status)
SELECT 'SUP-1001', 'Acme Logistics & Components', 'John Doe', 'john@acme.com', '+1-555-0192', '100 Industrial Parkway, Chicago, IL', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE supplier_code = 'SUP-1001');

INSERT INTO suppliers (supplier_code, name, contact_person, email, phone, address, status)
SELECT 'SUP-1002', 'Global Tech Distributors', 'Sarah Jenkins', 'sarah@globaltech.com', '+1-555-0144', '450 Tech Way, San Jose, CA', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE supplier_code = 'SUP-1002');

INSERT INTO suppliers (supplier_code, name, contact_person, email, phone, address, status)
SELECT 'SUP-1003', 'Apex Manufacturing Co.', 'Robert Chen', 'robert@apexmfg.com', '+1-555-0188', '789 Factory Rd, Detroit, MI', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE supplier_code = 'SUP-1003');

-- Seed Products
INSERT INTO products (product_code, name, category, unit_price, stock_quantity, reorder_level, description)
SELECT 'PRD-5001', 'Industrial Microcontroller Unit', 'Electronics', 45.50, 150, 20, 'High-performance MCU for automation panels'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_code = 'PRD-5001');

INSERT INTO products (product_code, name, category, unit_price, stock_quantity, reorder_level, description)
SELECT 'PRD-5002', 'Heavy Duty Hydraulic Valve', 'Hardware', 120.00, 8, 15, 'Precision pressure regulation valve'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_code = 'PRD-5002');

INSERT INTO products (product_code, name, category, unit_price, stock_quantity, reorder_level, description)
SELECT 'PRD-5003', 'Stainless Steel Bolt Pack (100pcs)', 'Fasteners', 18.75, 45, 10, 'Grade 316 weather-resistant M8 bolts'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_code = 'PRD-5003');

INSERT INTO products (product_code, name, category, unit_price, stock_quantity, reorder_level, description)
SELECT 'PRD-5004', 'Fiber Optic Transceiver Module', 'Networking', 89.99, 5, 10, '10Gbps Single-Mode SFP+ Transceiver'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_code = 'PRD-5004');
