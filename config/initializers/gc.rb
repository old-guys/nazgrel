if SERVICES_CONFIG["gc_profiler"].to_s == "true"
  GC::Profiler.enable
end