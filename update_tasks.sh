#!/bin/bash
TARGET="/Users/vortex/.gemini/antigravity/brain/e8ac83b4-47d9-4776-8f7a-597cf5a613b1/task.md"
sed -i '' 's/- \[ \] Service: `Meta::GraphClient`/- [x] Service: `Meta::GraphClient`/' "$TARGET"
sed -i '' 's/- \[ \] Método `get_lead_details/- [x] Método `get_lead_details/' "$TARGET"
sed -i '' 's/- \[ \] Método `get_ad(ad_id)/- [x] Método `get_ad(ad_id)/' "$TARGET"
sed -i '' 's/- \[ \] Método `get_ad_creative/- [x] Método `get_ad_creative/' "$TARGET"
sed -i '' 's/- \[ \] `Meta::LeadEnrichmentJob`/- [x] `Meta::LeadEnrichmentJob`/' "$TARGET"
sed -i '' 's/- \[ \] Step 3: \*\*Conditional enrichment\*\*/- [x] Step 3: **Conditional enrichment**/' "$TARGET"
