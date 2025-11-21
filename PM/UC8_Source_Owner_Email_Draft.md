Subject: UC8 – Work required from source owner to support query delivery for MIM contracts

Dear [PM name],

As discussed, we are preparing the next steps for UC8 so that the data engineering team can implement the Source → MIM queries based on the agreed MIM entities and data contracts. For this, we will need structured support from the source owner / application team.

Below is a proposed scope of work for the source owner that you can use to brief them and secure their commitment.

1. Understand the data contract and scope
- Review the MIM entity specifications and the Source–MIM mapping file (tables, columns, data types, business rules, and transformation logic) that we will provide.
- Confirm, for each MIM entity in scope, which tables in the source system hold the data needed to populate the MIM fields (no dependence on existing application views, as we only replicate tables in the ODS sync).
- Validate whether all fields defined in the contract can be sourced from the application data. Where this is not possible, identify and document the exceptions and limitations so we can capture them in the final documentation.

2. Design and deliver the source queries and lineage
- Design and build SQL queries on the source system that implement the business logic defined in the MIM contracts (one query or a small set of queries per MIM entity or logical group).
- Ensure that the queries:
  - Use the correct business rules and filters as described in the contract (so that the result matches what the contract expects), and
  - Are based on the underlying tables that will be replicated to the Data Backbone ODS (not on top of application views).
- Provide a clear data-lineage mapping per MIM entity that shows, for each MIM field:
  - The source table(s) and column(s) used, and
  - Any join, filter, or transformation logic that is applied in the query.
- Deliver the queries as SQL scripts (for example `.sql` files); we will take care of storing these in version control and integrating them in our orchestration. If useful, you can add short comments to explain non-obvious business logic or assumptions.

3. Validate coverage and document limitations
- Perform a basic functional check that the logic in the queries is consistent with how the application uses the data (for example: the right records are included/excluded and key business rules are respected).
- Confirm that the lineage mapping is complete (all MIM fields are either mapped to a column or explicitly marked as “not available / not applicable”).
- Document any known data-quality issues, structural limitations, or deviations from the contract (for example missing history, partial availability for certain affiliates, or fields that are only populated under specific conditions), so we can reflect these in the DQ and monitoring setup on the Data Backbone side.

4. Handover and change handling
- Provide the query scripts and the lineage document to the Data Backbone team in the agreed handover channel (for example via the project repository or shared folder).
- For future changes to the application model that impact the queries (new columns, code changes, deprecations, etc.), inform the Data Backbone team so we can update the queries and lineage consistently and keep the contract aligned with the actual source behaviour.

If you agree with this scope, I suggest we share it with the source owner and confirm:
- who will take each responsibility, and
- by when we need each deliverable to keep UC8 on track.

I’m happy to walk through this with you and adjust the wording before you send it out.

Kind regards,

[Your name]
[Your role]
