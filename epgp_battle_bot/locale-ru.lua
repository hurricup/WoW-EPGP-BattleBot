if GetLocale() ~= "ruRU" then return end

EPGP_BB_STATUS_VERSION = "WowRaider.Net EPGP Battle Bot %s."
EPGP_BB_STATUS_STATUS = "  Отслеживание событий: %s"
EPGP_BB_STATUS_AUTOLOGGING = "  Автоматическая запись комбатлога: %s"
EPGP_BB_STATUS_RULES = "  Добавлено правил: %s (введите /ebb list для просмотра)"

EPGP_BB_HELP = {
    EPGP_BB_STATUS_VERSION,
    "Команды настройки /epgpbb или /ebb. Список опций:",
    "  /ebb help - показать помощь",
    "  /ebb status - показать текущие настройки аддона",
    "  /ebb announce (say|guild|raid|party) - анонсировать активный набоор правил в указанный канал (по умолчанию, в рейд или в say, если игрок не в рейде)",
    "  /ebb list - показать список существующих правил",
    "  /ebb add value (EP|GP) for event - добавить новое правило начисления EP или GP при событии. Поддерживаются отрицательные числа. Доступные события:",
    "    death by spell_id - получение избыточного урона от способности по ее id",
    "    damagetaken by spell_id - получение урона от способности по ее id",
    "    buff spell_id [min_staks] - получение min_staks стаков баффа/дебаффа. 1 по умолчанию",
    "    interrupt spell_id - прерывание указанного заклинания",
    "    dispel spell_id - рассеивание баффа/дебаффа",
    "  /ebb protect by - защищает от штрафов за получение урона при условии:",
    "    cast spell_id - чтение заклинания spell_id (длинные и важные хилы)",
    "    buff spell_id - наличие баффа spell_id (антимагический панцирь)",
    "  /ebb del rule_id - удалить правило по id",
    "  /ebb enable rule_id - включить правило по id",
    "  /ebb disable rule_id - выключить правило по id",
    "  /ebb reset - сбросить настройки, удалть все правила",
    "  /ebb autologging (on|off) - включить или выключить автоматическую запись комбатлога при включении или выключении отслеживания",
    "  /ebb on - включить отслеживание, удобно использовать в макросе на пулл",
    "  /ebb off - отключает мониторинг, удобно использовать в макросе на вайп.",
}
EPGP_BB_CONFIG_RESET = "Конфигурация сброшена\n"
EPGP_BB_RULE_PH = "%d: (%s) %s" -- rule number, status, rule text
EPGP_BB_ACTIVE_RULES_HEADER = "Список действующих штрафов:"

EPGP_BB_RULE_DEATH_BY_PH = "%d %s за смерть от %s"
EPGP_BB_RULE_BUFF_BY_PH = "%d %s за получение баффа %s"
EPGP_BB_RULE_DAMAGE_TAKEN_BY_PH = "%d %s за получение урона от %s"
EPGP_BB_RULE_BUFF_STACKS_BY_PH = "%d %s за получение %d стаков бафа %s"
EPGP_BB_RULE_INTERRUPT_PH = "%d %s за прерывание %s"
EPGP_BB_RULE_DISPEL_PH = "%d %s за рассеивание/кражу %s"

EPGP_BB_RULE_PROTECT_CAST_PH = "иммунитет к штрафам за урон во время чтения заклинания %s"
EPGP_BB_RULE_PROTECT_BUFF_PH = "иммунитет к штрафам за урон с баффом %s"

EPGP_BB_RULE_NOT_FOUND = "Ошибка. Не могу найти правило %s. Список существующих правил:"
EPGP_BB_RULE_ENABLED = "Включено правило: %s"
EPGP_BB_RULE_DISABLED = "Выключено правило: %s"
EPGP_BB_RULE_DELETED = "Удалено правило: %s"
EPGP_BB_STATE = {
    [true] = "включено",
    [false] = "выключено",
}
EPGP_BB_SPELL_LINK = "|cff71d5ff|Hspell:%d|h[%s]|h|r"
EPGP_BB_CREATED_RULE = "Создано правило: %s"
EPGP_BB_REPLACED_RULE = "Замена правила: '%s' на '%s'"
EPGP_BB_ADDON_ENABLED = "EPGP Battle Bot активирован, будьте осторожны"
EPGP_BB_ADDON_DISABLED = "EPGP Battle Bot деактивирован, расслабьтесь"
EPGP_BB_LOGGING_ENABLED = "Включена запись журнала сражений"
EPGP_BB_LOGGING_DISABLED = "Запись журнала сражений выключена"

EPGP_BB_AUTOLOGGING_ENABLED = "Автоматическое управление записью журнала сражений включено"
EPGP_BB_AUTOLOGGING_DISABLED = "Автоматическое управление записью журнала сражений отключено"
