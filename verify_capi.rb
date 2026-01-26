# Create a test lead
lead = Lead.create!(
  meta_leadgen_id: "CAPI_TEST_#{Time.now.to_i}",
  full_name: "Capi Tester",
  email: "capi@test.com",
  platform: "ig",
  status: :new_lead # Start as new
)

puts "Lead Created: #{lead.full_name} (#{lead.status})"

# 2. Update status to Trigger Hook
puts "Updating status to 'converted'..."
lead.converted!

# 3. Check if Job was enqueued
# Note: In development using async adapter, it might execute immediately or queue.
puts "✅ Lead status is now: #{lead.status}"
puts "⚠️ Check server logs for 'CAPI Event Sent' or 'CAPI Error'"
