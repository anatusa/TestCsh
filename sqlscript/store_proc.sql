/*
	Together Fuzzy Search
	Copyright (C) 2011 Together Teamsolutions Co., Ltd.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see http://www.gnu.org/licenses
*/

/*
CREATE ASSEMBLY [TFS]
AUTHORIZATION [dbo]
FROM 'c:\Program Files\tfs-1.3-1\bin\tfs.dll'
WITH PERMISSION_SET = SAFE
*/

CREATE FUNCTION Levenstein(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.Levenstein
GO

CREATE FUNCTION NeedlemanWunch(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.NeedlemanWunch
GO

CREATE FUNCTION SmithWaterman(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.SmithWaterman
GO

CREATE FUNCTION SmithWatermanGotoh(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.SmithWatermanGotoh
GO

CREATE FUNCTION SmithWatermanGotohWindowedAffine(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.SmithWatermanGotohWindowedAffine
GO

CREATE FUNCTION Jaro(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.Jaro
GO

CREATE FUNCTION JaroWinkler(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.JaroWinkler
GO

CREATE FUNCTION ChapmanLengthDeviation(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.ChapmanLengthDeviation
GO

CREATE FUNCTION ChapmanMeanLength(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.ChapmanMeanLength
GO

CREATE FUNCTION QGramsDistance(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.QGramsDistance
GO

CREATE FUNCTION BlockDistance(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.BlockDistance
GO

CREATE FUNCTION CosineSimilarity(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.CosineSimilarity
GO

CREATE FUNCTION DiceSimilarity(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.DiceSimilarity
GO

CREATE FUNCTION EuclideanDistance(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.EuclideanDistance
GO

CREATE FUNCTION JaccardSimilarity(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.JaccardSimilarity
GO

CREATE FUNCTION MatchingCoefficient(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.MatchingCoefficient
GO

CREATE FUNCTION MongeElkan(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.MongeElkan
GO

CREATE FUNCTION OverlapCoefficient(@firstword NVARCHAR(255),@secondword NVARCHAR(255))
RETURNS float EXTERNAL NAME TextFunctions.StringMetrics.OverlapCoefficient
GO
