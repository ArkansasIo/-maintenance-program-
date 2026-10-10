CREATE DATABASE IF NOT EXISTS workplace_maintenance;
USE workplace_maintenance;

CREATE TABLE organizations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  country_code CHAR(2),
  default_currency CHAR(3),
  timezone VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sites (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  organization_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  address_line1 VARCHAR(255),
  city VARCHAR(120),
  region VARCHAR(120),
  postal_code VARCHAR(30),
  country_code CHAR(2),
  FOREIGN KEY (organization_id) REFERENCES organizations(id)
);

CREATE TABLE locations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  site_id BIGINT NOT NULL,
  parent_id BIGINT NULL,
  name VARCHAR(255) NOT NULL,
  location_type VARCHAR(80),
  FOREIGN KEY (site_id) REFERENCES sites(id),
  FOREIGN KEY (parent_id) REFERENCES locations(id)
);

CREATE TABLE employees (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  organization_id BIGINT NOT NULL,
  employee_number VARCHAR(80),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(80),
  active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (organization_id) REFERENCES organizations(id)
);

CREATE TABLE assets (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  site_id BIGINT NOT NULL,
  location_id BIGINT,
  asset_tag VARCHAR(120) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(120),
  manufacturer VARCHAR(160),
  model VARCHAR(160),
  serial_number VARCHAR(160),
  criticality VARCHAR(40) DEFAULT 'Medium',
  status VARCHAR(50) DEFAULT 'Active',
  install_date DATE,
  warranty_end DATE,
  notes TEXT,
  FOREIGN KEY (site_id) REFERENCES sites(id),
  FOREIGN KEY (location_id) REFERENCES locations(id)
);

CREATE TABLE work_orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  number VARCHAR(80) UNIQUE NOT NULL,
  site_id BIGINT NOT NULL,
  asset_id BIGINT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  job_type VARCHAR(80) NOT NULL,
  priority VARCHAR(40) DEFAULT 'Medium',
  status VARCHAR(50) DEFAULT 'Open',
  assigned_employee_id BIGINT,
  requested_by_id BIGINT,
  due_at DATETIME,
  completed_at DATETIME,
  estimated_cost DECIMAL(14,2),
  actual_cost DECIMAL(14,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (site_id) REFERENCES sites(id),
  FOREIGN KEY (asset_id) REFERENCES assets(id),
  FOREIGN KEY (assigned_employee_id) REFERENCES employees(id),
  FOREIGN KEY (requested_by_id) REFERENCES employees(id)
);

CREATE TABLE work_order_tasks (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  work_order_id BIGINT NOT NULL,
  description TEXT NOT NULL,
  status VARCHAR(40) DEFAULT 'Open',
  sequence_no INT DEFAULT 0,
  FOREIGN KEY (work_order_id) REFERENCES work_orders(id) ON DELETE CASCADE
);

CREATE TABLE parts (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  organization_id BIGINT NOT NULL,
  sku VARCHAR(120),
  name VARCHAR(255) NOT NULL,
  unit VARCHAR(40) DEFAULT 'ea',
  quantity DECIMAL(14,3) DEFAULT 0,
  reorder_level DECIMAL(14,3) DEFAULT 0,
  supplier VARCHAR(255),
  FOREIGN KEY (organization_id) REFERENCES organizations(id)
);

CREATE TABLE pm_schedules (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  asset_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  frequency_days INT NOT NULL,
  next_due DATE NOT NULL,
  checklist TEXT,
  active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (asset_id) REFERENCES assets(id)
);

CREATE TABLE inspections (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  asset_id BIGINT,
  inspector_id BIGINT NOT NULL,
  inspection_date DATETIME NOT NULL,
  result VARCHAR(60) NOT NULL,
  checklist TEXT,
  notes TEXT,
  FOREIGN KEY (asset_id) REFERENCES assets(id),
  FOREIGN KEY (inspector_id) REFERENCES employees(id)
);

CREATE TABLE audit_log (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  organization_id BIGINT,
  user_id BIGINT,
  event_type VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);