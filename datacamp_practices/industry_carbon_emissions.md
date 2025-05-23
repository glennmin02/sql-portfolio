When factoring heat generation required for the manufacturing and transportation of products, _Greenhouse gas emissions attributable to products, from food to sneakers to appliances, make up more than 75% of global emissions._ (`Source: The Carbon Catalogue https://www.nature.com/articles/s41597-022-01178-9`)

Our data, which is publicly available on nature.com, contains product carbon footprints (PCFs) for various companies. PCFs are the greenhouse gas emissions attributable to a given product, measured in CO<sub>2</sub> (carbon dioxide equivalent).
<!--https://www.nature.com/articles/s41597-022-01178-9-->

This data is stored in a PostgreSQL database containing one table, `product_emissions`, which looks at PCFs by product as well as the stage of production that these emissions occurred. Here's a snapshot of what `product_emissions` contains in each column:

### `product_emissions`

| field                              | data type |
|------------------------------------|-----------|
| `id`                                 | `VARCHAR`   |
| `year`                               | `INT`       |
| `product_name`                       | `VARCHAR`   |
| `company`                            | `VARCHAR`   |
| `country`                            | `VARCHAR`   |
| `industry_group`                     | `VARCHAR`   |
| `weight_kg`                          | `NUMERIC`   |
| `carbon_footprint_pcf`               | `NUMERIC`   |
| `upstream_percent_total_pcf`         | `VARCHAR`   |
| `operations_percent_total_pcf`       | `VARCHAR`   |
| `downstream_percent_total_pcf`       | `VARCHAR`   |

Using the product_emissions table, 
- Find the number of unique companies and their total carbon footprint PCF for each industry group, filtering for the most recent year in the database.
- The query should return three columns: industry_group, num_companies, and total_industry_footprint, with the last column being rounded to one decimal place.
- The results should be sorted by total_industry_footprint from highest to lowest values.
