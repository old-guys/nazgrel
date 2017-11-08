if SERVICES_CONFIG[:active_record_query_trace]
  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.level = :app # default
  ActiveRecordQueryTrace.ignore_cached_queries = true # Default is false.
  # ActiveRecordQueryTrace.lines = 10 # Default is 5. Setting to 0 includes entire trace.
  # ActiveRecordQueryTrace.colorize = false # No colorization(default)
  # ActiveRecordQueryTrace.colorize = 'light purple'
  ActiveRecordQueryTrace.colorize = true # Colorize in default color
  # ActiveRecordQueryTrace.colorize = 35 # Magenta
end
