USE [medtech]
GO

/****** Object:  View [dbo].[vw_assessment_detail]    Script Date: 7/7/2024 10:38:59 AM ******/
DROP VIEW [dbo].[vw_assessment_website_views]
GO

/****** Object:  View [dbo].[vw_assessment_detail]    Script Date: 7/7/2024 10:38:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_assessment_response_dropoff_rate]
AS
SELECT 
	resps.question, 
	resps.question_order,
	vws.viewCount, 
	resps.respCount, 
	CAST((CAST(vws.viewCount AS decimal(10, 6)) - CAST(resps.respCount AS decimal(10, 6))) / CAST(vws.viewCount AS decimal(10, 6)) AS decimal(5, 2)) AS drop_rate
FROM  
	(SELECT 
		mapping.question, 
		mapping.page_hits, 
		mapping.question_order, 
		COUNT(*) AS viewCount
	FROM  
		wordpress.wp_medibles_advisor_question_hits AS hits WITH (nolock) INNER JOIN
		wordpress.wp_medibles_advisor_question_hits_mapping AS mapping WITH (nolock) ON hits.page_hits = mapping.page_hits
	WHERE 
		(mapping.page_hits LIKE 'view%')
	GROUP BY 
		mapping.question, mapping.page_hits, mapping.question_order
	) AS vws INNER JOIN
	(SELECT 
		mapping.question, 
		mapping.page_hits, 
		mapping.question_order, 
		COUNT(*) AS respCount
	FROM  
		wordpress.wp_medibles_advisor_question_hits AS hits WITH (nolock) INNER JOIN
		wordpress.wp_medibles_advisor_question_hits_mapping AS mapping WITH (nolock) ON hits.page_hits = mapping.page_hits
	WHERE 
		(mapping.page_hits LIKE 'resp%')
	GROUP BY 
		mapping.question, 
		mapping.page_hits, 
		mapping.question_order
	) AS resps ON vws.question = resps.question

GO
