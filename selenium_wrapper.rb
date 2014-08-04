def fill_in(id, text)
  element = driver.find_element(id: id)
  element.click
  element.send_keys(text)
end

def select(id, text)
  element = driver.find_element(id: id)
  options = Selenium::WebDriver::Support::Select.new(element)
  options.select_by(:text, text)
end

def driver
  @driver ||= Selenium::WebDriver.for :chrome, switches: ['--test-type']
end
