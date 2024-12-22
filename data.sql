SELECT 
    COUNT(*) AS TotalRows, 
    SUM(CASE WHEN Color IS NULL THEN 1 ELSE 0 END) AS NullColors,
    SUM(CASE WHEN Weight IS NULL THEN 1 ELSE 0 END) AS NullWeights,
    SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS NullSizes
FROM Production.Product;
-- Update NULL values for Color
UPDATE Production.Product
SET Color = 'Unknown'
WHERE Color IS NULL;
-- Update NULL values for Weight
UPDATE Production.Product
SET Weight = 1
WHERE Weight IS NULL;
-- Update NULL values for Size (assuming 'Not Specified' is the default value)
UPDATE Production.Product
SET Size = 'N/A'
WHERE Size IS NULL;
SELECT Name, ProductNumber, COUNT(*) AS DuplicateCount
FROM Production.Product
GROUP BY Name, ProductNumber
HAVING COUNT(*) > 1;
SELECT ProductID, SellStartDate, SellEndDate
FROM Production.Product
WHERE SellStartDate > SellEndDate OR SellStartDate IS NULL;

SELECT p.ProductID, p.ProductSubcategoryID
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.ProductSubcategoryID IS NULL;
SELECT ProductID, StandardCost, ListPrice
FROM Production.Product
WHERE StandardCost > ListPrice;
SELECT 
    SUM(CASE WHEN Color = 'Unknown' THEN 1 ELSE 0 END) AS DefaultColors,
    COUNT(*) AS TotalRowsAfterCleaning
FROM Production.Product;
SELECT TOP 10 *
FROM Production.Product;
-- Update NULL values for SafetyStockLevel with a default value, e.g., 0
UPDATE Production.Product
SET SafetyStockLevel = 0
WHERE SafetyStockLevel IS NULL;
-- Update NULL values for ReorderPoint with a default value, e.g., 0
UPDATE Production.Product
SET ReorderPoint = 0
WHERE ReorderPoint IS NULL;
-- Update NULL values for StandardCost with a default value, e.g., 0
UPDATE Production.Product
SET StandardCost = (
    SELECT AVG(StandardCost)
    FROM Production.Product AS p2
    WHERE p2.ProductSubcategoryID = Production.Product.ProductSubcategoryID
    AND p2.StandardCost IS NOT NULL
)
WHERE StandardCost IS NULL;
-- Update NULL values for ListPrice with a default value, e.g., 0
UPDATE Production.Product
SET ListPrice = (
    SELECT AVG(ListPrice)
    FROM Production.Product AS p2
    WHERE p2.ProductSubcategoryID = Production.Product.ProductSubcategoryID
    AND p2.ListPrice IS NOT NULL
)
WHERE ListPrice IS NULL;
-- Update NULL values for SizeUnitMeasureCode with a default value, e.g., 'N/A'
UPDATE Production.Product
SET SizeUnitMeasureCode = 'N/A'
WHERE SizeUnitMeasureCode IS NULL;

-- Update NULL values for WeightUnitMeasureCode with a default value, e.g., 'N/A'
UPDATE Production.Product
SET WeightUnitMeasureCode = 'N/A'
WHERE WeightUnitMeasureCode IS NULL;
-- Update NULL values for DaysToManufacture with a default value, e.g., 0
UPDATE Production.Product
SET DaysToManufacture = (
    SELECT AVG(DaysToManufacture)
    FROM Production.Product AS p2
    WHERE p2.ProductSubcategoryID = Production.Product.ProductSubcategoryID
    AND p2.DaysToManufacture IS NOT NULL
)
WHERE DaysToManufacture IS NULL;
-- Ajouter une valeur dans UnitMeasure si nécessaire
IF NOT EXISTS (
    SELECT 1 
    FROM Production.UnitMeasure 
    WHERE UnitMeasureCode = 'NA'
)
BEGIN
    INSERT INTO Production.UnitMeasure (UnitMeasureCode, Name, ModifiedDate)
    VALUES ('NA', 'Not Applicable', GETDATE());
END
-- Mettre à jour les colonnes avec des valeurs valides
UPDATE Production.Product
SET SizeUnitMeasureCode = 'NA'
WHERE SizeUnitMeasureCode IS NULL;

UPDATE Production.Product
SET WeightUnitMeasureCode = 'NA'
WHERE WeightUnitMeasureCode IS NULL;
-- Corriger la troncation des chaînes



-- Supprimer la contrainte CHECK
ALTER TABLE Production.Product DROP CONSTRAINT CK_Product_ProductLine;

-- Modifier la colonne
ALTER TABLE Production.Product ALTER COLUMN ProductLine NVARCHAR(3);

-- Recréer la contrainte CHECK si nécessaire
ALTER TABLE Production.Product 
ADD CONSTRAINT CK_Product_ProductLine 
CHECK (ProductLine IN ('R', 'M', 'T', 'S', 'N'));

-- 1. Supprimer la contrainte existante
ALTER TABLE Production.Product DROP CONSTRAINT CK_Product_Class;

-- 2. Modifier la colonne
ALTER TABLE Production.Product ALTER COLUMN Class NVARCHAR(3);

-- 3. Recréer la contrainte CHECK
ALTER TABLE Production.Product 
ADD CONSTRAINT CK_Product_Class 
CHECK (Class IN ('H', 'M', 'L', 'N'));

ALTER TABLE Production.Product
DROP CONSTRAINT CK_Product_Style;

ALTER TABLE Production.Product
ALTER COLUMN Style NVARCHAR(3);

ALTER TABLE Production.Product
ADD CONSTRAINT CK_Product_Style 
CHECK (Style IN ('U', 'M', 'W', 'N'));

SELECT 
    COUNT(*) AS TotalRows, 
    SUM(CASE WHEN SellStartDate IS NULL THEN 1 ELSE 0 END) AS NullSellStartDate
FROM Production.Product;


-- Update NULL values for rowguid with a default value, e.g., NEWID()
UPDATE Production.Product
SET rowguid = NEWID()
WHERE rowguid IS NULL;

-- Update NULL values for ModifiedDate with the current timestamp
UPDATE Production.Product
SET ModifiedDate = GETDATE()
WHERE ModifiedDate IS NULL;

