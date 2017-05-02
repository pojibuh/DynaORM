CREATE TABLE store (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  organization_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE organizations (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  organizations (id, name)
VALUES
  (1, "McDonalds"), (2, "Subway");

INSERT INTO
  humans (id, fname, lname, organization_id)
VALUES
  (1, "Moktar", "Jama", 1),
  (2, "Tayo", "Glover", 1),
  (3, "Gordon", "Stern", 2),
  (4, "Cody", "Young", NULL);

INSERT INTO
  store (id, name, owner_id)
VALUES
  (1, "Chelsea McDonalds", 1),
  (2, "East Village McDonalds", 2),
  (3, "Hell's Kitchen Subway", 3),
  (4, "Harlem Subway", 3),
  (5, "Closed Store", NULL);
