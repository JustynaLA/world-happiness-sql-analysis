# Exploring Global Happiness with SQL (2019)

**Do richer countries report greater happiness, and what else matters?**
An analysis of the World Happiness Report 2019 dataset (156 countries) in PostgreSQL.
SQL course project, awarded **Distinction**.

## Key findings

- The average global happiness score in 2019 was **5.41 out of 10**, with large gaps between nations.
- **Wealth alone does not determine happiness.** Qatar had the highest GDP per capita but a happiness score of 6.37, only moderately above the global average. Singapore ranked 3rd for GDP but 34th for happiness.
- The happiest countries (Finland, Denmark, Norway) combine **strong social support with personal freedom**.
- Lower perceived corruption tends to go with higher happiness, with one clear exception: **Rwanda**, which has low perceived corruption but low happiness.
- Countries with above-average generosity had slightly higher average happiness (5.46 vs 5.36), a small difference that suggests generosity is one factor among several.

**Recommendation:** policymakers should take a multidimensional approach to wellbeing, investing in governance transparency, healthcare, social protection and personal freedoms, not only economic growth.

## SQL techniques used

| Technique | Used for |
|---|---|
| `ORDER BY`, `LIMIT` | Rankings, top and bottom 10 |
| `AVG`, `COUNT`, `ROUND` | Dataset overview and global averages |
| `CASE` with a subquery | Grouping countries above or below average generosity |
| `GROUP BY` | Comparing averages between groups |
| Window functions: `RANK()`, `NTILE()` | GDP rank vs happiness rank; three happiness groups |
| CTE (`WITH`) | Building rankings before comparing them |
| `ABS()` | Measuring the size of the gap between two ranks |

## Files

| File | Contents |
|---|---|
| [`world_happiness_2019_queries.sql`](world_happiness_2019_queries.sql) | All queries, numbered to match the presentation |
| [`Exploring_Global_Happiness_with_SQL_2019.pdf`](Exploring_Global_Happiness_with_SQL_2019.pdf) | Presentation with results, charts and conclusions |

## Notes and limitations

- In this dataset, a **higher** `perceptions_of_corruption` value means **less** corruption is perceived.
- The comparisons show patterns, not causes. Correlation analysis would be needed to measure how strongly each factor relates to happiness.
- **Two ways to group countries into High, Medium and Low happiness:** `NTILE(3)` (query 12) creates three equal groups of 52 by rank, so the even split reflects the method, not the data. Fixed score thresholds (query 12b: 7 and above is High, 5 to 6.99 is Medium) group countries by their actual score, so group sizes differ. The method changes the answer to "Is this a high-happiness country?", which is why the method should always be stated alongside the result.

## Next steps

- **Measure the strength of each relationship** with PostgreSQL's `CORR()` function, for example `CORR(gdp_per_capita, score)`, to move from comparing averages to a single correlation figure.
- **Find countries that are happier than their GDP predicts**, building on the rank-gap analysis in query 10.
- **Compare regions** by joining a country-to-region table, to reveal patterns that country-level analysis can miss.

## Data

[World Happiness Report](https://worldhappiness.report/) 2019 dataset: one row per country, with the happiness score and six contributing factors (GDP per capita, social support, healthy life expectancy, freedom to make life choices, generosity and perceptions of corruption).
