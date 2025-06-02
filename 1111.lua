local processName = "HD-Player.exe"
local pid = getProcessIDFromProcessName(processName)

if pid == nil then
  showMessage("❌ Emulator not found! Please open Fast Emulator (HD-Player).")
  return
end

openProcess(processName)
showMessage("✅ HD-Player found. Starting Injection...")

-- قائمة أنماط البحث والاستبدال
local patterns = {
  {search = "7B F9 6C BD 58 34 09 BB", replace = "CD DC 79 44 58 34 09 BB"},
  {search = "BC 19 FD BD B0 E3 A9", replace = "CD DC 79 44 B0 E3 A9"},
  {search = "80 13 95 BC 30 FF 37 BB", replace = "CD DC 79 44 30 FF 37 BB"},
  {search = "CC F8 6C BD 40 D2 CE", replace = "CD DC 79 44 40 D2 CE"},
  {search = "BD 27 C1 8B 3C C0 D0 F8 B9",
   replace = "3E 0A D7 23 3D D2 A5 F9 BC"},
  {search = "A8 E7 71 3D E4 8C 02 3E 00 00 00 00", replace = "59 DF CA 3D E4 8C 02 3E"},
  {search = "7D 1A 89 BD 50 26 9F 3B", replace = "00 00 70 41 00 00 70 41"},
  {search = "63 71 B0 BD 90 98 74 BB", replace = "00 00 70 41 00 00 70 41"}
}

local totalCount = 0

-- دالة لتحويل نص البايت من سترينغ إلى جدول أعداد صحيحة
local function hexStringToByteArray(hexStr)
  local bytes = {}
  for byte in hexStr:gmatch("%x%x") do
    table.insert(bytes, tonumber(byte, 16))
  end
  return bytes
end

for _, p in ipairs(patterns) do
  local result = AOBScan(p.search)
  if result == nil or result.Count == 0 then
    showMessage("⚠️ Pattern not found: " .. p.search)
  else
    local replaceBytes = hexStringToByteArray(p.replace)
    for i = 0, result.Count - 1 do
      local baseAddr = tonumber(result[i], 16)
      -- كتابة البايتات في الذاكرة عند العنوان baseAddr
      writeBytes(baseAddr, replaceBytes)
      totalCount = totalCount + 1
    end
    result.destroy()
  end
end

if totalCount > 0 then
  showMessage("✅ Injection completed! Total replaced patterns: " .. totalCount)
else
  showMessage("❌ No patterns replaced.")
end
