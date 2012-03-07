class String

  def jzip_require_statement?
    !!self.strip.match(Jzip::Engine::REG_EXPS[:require_statement])
  end

  def required_jzip_source(exclude_exclamation_mark = true)
    self.strip.gsub(Regexp.new([Jzip::Engine::REG_EXPS[:require_statement].source, ("\!?" if exclude_exclamation_mark)].compact.join), "").strip if self.jzip_require_statement?
  end

  def overrule_jzip_minification?
    !!required_jzip_source(false).match(/^!/) if self.jzip_require_statement?
  end

end