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
INSERT INTO Production.UnitMeasure (UnitMeasureCode, Name, ModifiedDate)
VALUES ('NA', 'Not Applicable', GETDATE());

-- Mettre à jour les colonnes avec des valeurs valides
UPDATE Production.Product
SET SizeUnitMeasureCode = 'NA'
WHERE SizeUnitMeasureCode IS NULL;

UPDATE Production.Product
SET WeightUnitMeasureCode = 'NA'
WHERE WeightUnitMeasureCode IS NULL;

-- Corriger la troncation des chaînes
ALTER TABLE Production.Product
ALTER COLUMN ProductLine NVARCHAR(3);
ALTER TABLE Production.Product
ALTER COLUMN Class NVARCHAR(3);
ALTER TABLE Production.Product
ALTER COLUMN Style NVARCHAR(3);

-- Refaire les mises à jour pour ProductLine, Class et Style
UPDATE Production.Product
SET ProductLine = 'N'
WHERE ProductLine IS NULL;

UPDATE Production.Product
SET Class = 'N'
WHERE Class IS NULL;

UPDATE Production.Product
SET Style = 'N'
WHERE Style IS NULL;


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



SELECT 
    cc.name AS ConstraintName,
    t.name AS TableName,
    c.name AS ColumnName,
    cc.definition AS ConstraintDefinition
FROM 
    sys.check_constraints cc
    INNER JOIN sys.objects t ON cc.parent_object_id = t.object_id
    INNER JOIN sys.columns c ON cc.parent_object_id = c.object_id 
        AND cc.parent_column_id = c.column_id
WHERE 
    t.name = 'Product' 
    AND c.name = 'Style';
