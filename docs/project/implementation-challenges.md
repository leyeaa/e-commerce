# Implementation challenge register

This register records difficulties that actually occurred during the project,
their effect on validity or progress, the response taken, and any remaining
limitation. Product defects discovered by testing are kept in defect-log.csv;
this file concerns challenges in designing, executing, evidencing, and reporting
the verification project itself.

| ID | Challenge encountered | Effect or risk | Response and evidence | Residual limitation / lesson |
| --- | --- | --- | --- | --- |
| CH-01 | The existing application already contained defects identified during preliminary inspection. Fixing them first would have changed the software under study and contaminated the comparison. | Later tests could be credited with finding defects that had already been removed, or different techniques could run against different behavior. | Froze commit acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4, registered K defects, prohibited product fixes during baseline execution, and allowed only test instrumentation. See baseline.md and known-defects.md. | The formal techniques mainly reproduced known defects and found no novel root cause. That outcome must be reported honestly rather than hidden or inflated. |
| CH-02 | Manual tests, fuzzing, and exploratory work all mutate PostgreSQL state; order creation empties carts and creates persistent orders. | Development data could be damaged, and one generated request could change the precondition of the next request. | Added separate test and fuzz settings, database-name safety checks, deterministic experiment users/products, snapshot commands, and a Schemathesis before-call restoration hook. | The hook improves repeatability but also creates a controlled state that may differ from unrestricted production sequences; this is disclosed as an instrumentation influence. |
| CH-03 | The first generated OpenAPI/error model did not accurately describe every 401 and parse-error response or restrict request media closely enough. | Schemathesis initially reported schema/instrumentation failures that were not application defects. | Hardened the test-only schema and response descriptions before formal execution, restricted requests to JSON, and retained the pre-formal validation logs. See the 20:34:03 and 20:39:15 Schemathesis artifacts. | Schema-driven testing is only as trustworthy as the contract. Harness failures and schema inaccuracies must remain separate from product defects. |
| CH-04 | A formal F-01 attempt exceeded the external orchestration allowance and was terminated before the generator completed. | Treating the partial log as formal would undercount cases and break comparability with the other seeds. | Preserved schemathesis-20260714-204316.log as an invalid partial run, then repeated F-01 with the same seed, schema, budget, baseline, and reset hook; only the external process allowance changed. | Tool duration depends partly on the surrounding execution environment. The invalid attempt is reported rather than silently deleted. |
| CH-05 | M-01 produced an unexpected pass for the proposed K-008 malformed-item-identifier defect. | The preliminary defect catalogue and manual defect count could have contained a false classification. | Investigated the original request and found that it used a valid item identifier with malformed quantity, duplicating K-002. K-008 was rejected and retained as an audit row rather than rerunning M-01 for a preferred result. | Preliminary inspection and smoke testing can be wrong. Strict expected failures were useful because they forced review instead of allowing the mistake to disappear. |
| CH-06 | JWT expiry occurred during exploratory workflows while the interface still appeared logged in and produced misleading empty-cart or generic Order failed states. | It interrupted the intended action, confused the address-punctuation investigation, and could have caused the tester to blame valid input. | Captured 401 request logs and database snapshots, reauthenticated, fully reloaded where needed, and retried the identical punctuation-rich address. This confirmed N-002 and separated authentication failure from address handling. | Authentication lifetime affected two sessions. The same tester had to investigate and recover within the timebox, reducing coverage of other charter areas. |
| CH-07 | Human time for manual-suite design, Schemathesis configuration, and cross-technique triage was not recorded prospectively. | The proposed setup-effort comparison cannot be quantified reliably, and tool wall-clock time is not an acceptable substitute. | Reported the formal human-effort values as unavailable, retained actual tool durations, and recorded the tester's 30/60-minute allocations for each exploratory session. | Quantitative effort comparison is incomplete and remains a construct-validity limitation. Future work should use a contemporaneous person-minute work log. |

## Cross-cutting lessons

1. Freeze the application and classify known defects before comparing
   techniques; do not fix the experimental subject mid-study.
2. Validate the test harness and API schema separately from application
   behavior, retaining invalid runs as audit evidence.
3. Reset state deliberately for destructive APIs, while disclosing how the
   reset strategy affects realism.
4. Treat unexpected passes and confusing exploratory outcomes as investigation
   triggers, not inconvenient results to rerun away.
5. Plan human-effort logging before the experiment begins.
