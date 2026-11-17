-- Embedded from Disenchantry 1.2.6 (MIT); see LICENSE.txt and NOTICE.txt.
local _, FT = ...
local GetLocale = GetLocale or function() return "deDE" end
local function LoadComponent(...)
-- Columns: French, Spanish (Spain/Latin America), Italian, Portuguese,
-- Korean, Simplified Chinese, Traditional Chinese. Keep format tokens intact.
local _, ns = ...
local languages = {"frFR", "esES", "itIT", "ptBR", "koKR", "zhCN", "zhTW"}
ns.LocaleCatalog = ns.LocaleCatalog or {}
for _, locale in ipairs(languages) do ns.LocaleCatalog[locale] = {} end
local function rows(block, locales)
    locales = locales or languages
    for _, locale in ipairs(locales) do ns.LocaleCatalog[locale] = ns.LocaleCatalog[locale] or {} end
    for row in block:gmatch("[^\r\n]+") do
        local fields = {}
        for field in (row .. "|"):gmatch("(.-)|") do fields[#fields + 1] = field end
        assert(#fields == #locales + 1, "Invalid locale row: " .. fields[1])
        for index, locale in ipairs(locales) do
            ns.LocaleCatalog[locale][fields[1]] = fields[index + 1]:gsub("\\n", "\n")
        end
    end
end
rows([=[
AUCTIONATOR_SOURCE|Source de prix Auctionator|Fuente de precios de Auctionator|Fonte prezzi Auctionator|Fonte de preços do Auctionator|Auctionator 가격 출처|Auctionator价格来源|Auctionator價格來源
AUCTIONATOR_LAST|Dernier prix relevé|Último precio registrado|Ultimo prezzo rilevato|Último preço registrado|마지막 확인 가격|最近记录价格|最近記錄價格
AUCTIONATOR_AVERAGE|Moyenne (%d jours)|Media (%d días)|Media (%d giorni)|Média (%d dias)|평균 (%d일)|平均价格（%d天）|平均價格（%d天）
AUCTIONATOR_SOURCE_HINT|La moyenne utilise la période définie dans Auctionator. Sans historique, le prix est inconnu. TSM reste prioritaire.|La media usa el período de Auctionator. Sin historial, el precio es desconocido. TSM tiene prioridad.|La media usa il periodo di Auctionator. Senza storico, il prezzo è sconosciuto. TSM ha la priorità.|A média usa o período do Auctionator. Sem histórico, o preço é desconhecido. TSM tem prioridade.|평균은 Auctionator에 설정된 기간을 사용합니다. 기록이 없으면 가격을 알 수 없습니다. TSM이 우선합니다.|平均价格使用Auctionator设置的时间范围。无历史记录时价格未知。TSM优先。|平均價格使用Auctionator設定的時間範圍。無歷史記錄時價格未知。TSM優先。
SHOW_DE_MATERIALS|Afficher les matériaux possibles|Mostrar materiales posibles|Mostra materiali possibili|Mostrar materiais possíveis|획득 가능한 재료 표시|显示可能获得的材料|顯示可能獲得的材料
SHOW_DE_CHANCES|Afficher les probabilités (%)|Mostrar probabilidades (%)|Mostra probabilità (%)|Mostrar probabilidades (%)|획득 확률 표시 (%)|显示获得几率（%）|顯示獲得機率（%）
SHOW_DE_VALUE|Afficher la valeur de désenchantement estimée|Mostrar valor de desencantamiento estimado|Mostra valore stimato del disincantamento|Mostrar valor estimado de desencantamento|마력 추출 예상 가치 표시|显示预计分解价值|顯示預計分解價值
DE_MATERIALS|Matériaux possibles|Materiales posibles|Materiali possibili|Materiais possíveis|획득 가능한 재료|可能获得的材料|可能獲得的材料
HIDE_MATERIALS|Masquer|Ocultar|Nascondi|Ocultar|숨기기|隐藏|隱藏
SHOW_MATERIALS|Afficher|Mostrar|Mostra|Mostrar|표시|显示|顯示
TOGGLE_MATERIALS_HINT|Afficher ou masquer les matériaux et probabilités dans les deux vues et les infobulles|Mostrar u ocultar materiales y probabilidades en ambas vistas y descripciones|Mostra o nascondi materiali e probabilità in entrambe le viste e nelle descrizioni|Mostrar ou ocultar materiais e probabilidades nas duas visualizações e dicas|두 보기와 아이템 툴팁에서 재료와 확률 표시 또는 숨기기|在两种视图和物品提示中显示或隐藏材料及几率|在兩種檢視和物品提示中顯示或隱藏材料及機率
PREVIOUS_ITEM|Objet précédent|Objeto anterior|Oggetto precedente|Item anterior|이전 아이템|上一个物品|上一個物品
NEXT_ITEM|Objet suivant|Objeto siguiente|Oggetto successivo|Próximo item|다음 아이템|下一个物品|下一個物品
ADDED_AUTO|Cet objet ne peut pas être désenchanté : ajouté aux exclusions|No se puede desencantar el objeto: añadido a exclusiones|L'oggetto non può essere disincantato: aggiunto alle esclusioni|O item não pode ser desencantado: adicionado às exclusões|마력 추출할 수 없는 아이템입니다. 제외 목록에 추가했습니다.|该物品无法分解，已加入排除列表|此物品無法分解，已加入排除清單
ADDED_MANUAL|Objet ajouté aux exclusions|Objeto añadido a exclusiones|Oggetto aggiunto alle esclusioni|Item adicionado às exclusões|제외 목록에 아이템을 추가했습니다.|物品已加入排除列表|物品已加入排除清單
BLACKLIST_CLEARED|Exclusions effacées.|Exclusiones borradas.|Esclusioni cancellate.|Exclusões limpas.|제외 목록을 비웠습니다.|排除列表已清空。|排除清單已清空。
BLACKLIST_EMPTY|Aucune exclusion.|No hay exclusiones.|Nessuna esclusione.|Nenhuma exclusão.|제외 목록이 비어 있습니다.|排除列表为空。|排除清單為空。
BLACKLIST_ITEM_BUTTON|Exclure|Excluir|Escludi|Excluir|제외|排除|排除
BLACKLIST_SUBTITLE|Retirez ici des objets des exclusions|Quita objetos de las exclusiones aquí|Rimuovi qui gli oggetti dalle esclusioni|Remova itens das exclusões aqui|여기에서 제외한 아이템을 목록으로 되돌릴 수 있습니다|在此将排除的物品恢复到列表|在此將排除的物品恢復至清單
BLACKLIST_TITLE|Exclusions|Exclusiones|Esclusioni|Exclusões|제외 목록|排除列表|排除清單
CHECK_ALL_OK|Vérifications réussies. /ed copy ouvre un rapport à copier.|Comprobaciones correctas. /ed copy abre un informe para copiar.|Controlli superati. /ed copy apre un rapporto da copiare.|Verificações concluídas. /ed copy abre um relatório para copiar.|모든 검사를 통과했습니다. /ed copy로 복사 가능한 보고서를 엽니다.|检查全部通过。输入/ed copy打开可复制的报告。|檢查全部通過。輸入/ed copy開啟可複製的報告。
CHECK_COPY_HINT|Ctrl+A pour tout sélectionner, Ctrl+C pour copier, puis collez dans votre rapport de bug.|Ctrl+A para seleccionar todo, Ctrl+C para copiar y pegar en tu informe de error.|Ctrl+A per selezionare tutto, Ctrl+C per copiare e incollare nella segnalazione.|Ctrl+A para selecionar tudo, Ctrl+C para copiar e colar no relatório de erro.|Ctrl+A로 모두 선택하고 Ctrl+C로 복사한 뒤 오류 보고서에 붙여 넣으세요.|Ctrl+A全选，Ctrl+C复制，然后粘贴到错误报告中。|Ctrl+A全選，Ctrl+C複製，然後貼到錯誤報告中。
CHECK_TITLE|Diagnostic|Diagnóstico|Diagnostica|Diagnóstico|진단|诊断|診斷
CLEAR_ALL|Tout effacer|Borrar todo|Cancella tutto|Limpar tudo|모두 지우기|全部清除|全部清除
CLEAR_SELECTION|Désélectionner|Deseleccionar|Deseleziona|Desmarcar|선택 해제|取消选择|取消選取
COMPACT_BLACKLIST_HINT|Clic droit : exclure cet objet|Clic derecho: excluir este objeto|Clic destro: escludi questo oggetto|Clique direito: excluir este item|우클릭: 이 아이템 제외|右键：排除此物品|右鍵：排除此物品
COMPACT_BLACKLIST_HINT_MILLING|Clic droit : exclure cette plante|Clic derecho: excluir esta hierba|Clic destro: escludi questa erba|Clique direito: excluir esta erva|우클릭: 이 약초 제외|右键：排除此草药|右鍵：排除此草藥
COMPACT_BLACKLIST_HINT_PROSPECTING|Clic droit : exclure ce minerai|Clic derecho: excluir este mineral|Clic destro: escludi questo minerale|Clique direito: excluir este minério|우클릭: 이 광석 제외|右键：排除此矿石|右鍵：排除此礦石
COMPACT_BUTTON|Compact|Compacto|Compatto|Compacto|간략히|紧凑|精簡
COMPACT_EMPTY|Rien à désenchanter|Nada que desencantar|Nulla da disincantare|Nada para desencantar|마력 추출할 아이템 없음|没有可分解的物品|沒有可分解的物品
COMPACT_EMPTY_MILLING|Rien à moudre|Nada que moler|Nulla da macinare|Nada para triturar|제분할 약초 없음|没有可研磨的草药|沒有可研磨的草藥
COMPACT_EMPTY_PROSPECTING|Rien à prospecter|Nada que prospectar|Nulla da prospettare|Nada para prospectar|보석 추출할 광석 없음|没有可选矿的矿石|沒有可勘探的礦石
COMPACT_QUEUE|En attente : %d|En cola: %d|In coda: %d|Na fila: %d|대기열: %d|队列：%d|佇列：%d
COMPACT_QUEUE_MILLING|À moudre : %d|Para moler: %d|Da macinare: %d|Para triturar: %d|제분 대기: %d|待研磨：%d|待研磨：%d
COMPACT_QUEUE_PROSPECTING|À prospecter : %d|Para prospectar: %d|Da prospettare: %d|Para prospectar: %d|보석 추출 대기: %d|待选矿：%d|待勘探：%d
COMPACT_SKIPPED_MANY|%d objets de valeur ignorés|%d objetos valiosos omitidos|%d oggetti di valore saltati|%d itens valiosos ignorados|고가 아이템 %d개 건너뜀|已跳过%d件高价值物品|已略過%d件高價值物品
COMPACT_SKIPPED_ONE|1 objet de valeur ignoré|1 objeto valioso omitido|1 oggetto di valore saltato|1 item valioso ignorado|고가 아이템 1개 건너뜀|已跳过1件高价值物品|已略過1件高價值物品
DELETE|Retirer|Quitar|Rimuovi|Remover|제거|移除|移除
DE_EXPECTED_VALUE|Valeur de désenchantement estimée|Valor de desencantamiento estimado|Valore stimato del disincantamento|Valor estimado de desencantamento|마력 추출 예상 가치|预计分解价值|預計分解價值
DE_RESULTS|Matériaux possibles (probabilités estimées)|Materiales posibles (probabilidades estimadas)|Materiali possibili (probabilità stimate)|Materiais possíveis (probabilidades estimadas)|획득 가능한 재료 (예상 확률)|可能获得的材料（估计几率）|可能獲得的材料（估計機率）
DE_UNKNOWN|Aucune donnée|Sin datos|Nessun dato|Sem dados|데이터 없음|无数据|無資料
DE_BASELINE_VALUE|Valeur de désenchantement approximative|Valor de desencantamiento aproximado|Valore approssimativo del disincantamento|Valor aproximado de desencantamento|마력 추출 대략적 가치|大致分解价值|大致分解價值
DE_RETAIL_ESTIMATE|Estimation de base, hors compétence et spécialisation. R = rang du composant.|Estimación base sin habilidad ni especialización. R = rango del componente.|Stima base senza abilità e specializzazione. R = grado del reagente.|Estimativa básica sem perícia e especialização. R = grau do reagente.|기술과 전문화를 반영하지 않은 기본 추정치입니다. R = 재료 등급.|基础估值，不含技能和专精影响。R＝材料品质等级。|基礎估值，不含技能和專精影響。R＝材料品質等級。
DISENCHANT|Désenchanter|Desencantar|Disincanta|Desencantar|마력 추출|分解|分解
DISENCHANT_COUNT|Désenchanter (%d)|Desencantar (%d)|Disincanta (%d)|Desencantar (%d)|마력 추출 (%d)|分解（%d）|分解（%d）
FOUND_COUNT|Trouvés : %d|Encontrados: %d|Trovati: %d|Encontrados: %d|발견: %d|找到：%d|找到：%d
FULL_BUTTON|Complet|Completo|Completo|Completo|전체|完整|完整
]=])
rows([=[
HELP_CHECK|lancer le diagnostic|ejecutar el diagnóstico|avvia la diagnostica|executar diagnóstico|진단 실행|运行诊断|執行診斷
HELP_CLEARBLACKLIST|effacer les exclusions du mode actuel|borrar exclusiones del modo actual|cancella le esclusioni della modalità attuale|limpar exclusões do modo atual|현재 모드의 제외 목록 비우기|清空当前模式的排除列表|清空目前模式的排除清單
HELP_COMPACT|afficher/masquer la barre compacte|mostrar/ocultar barra compacta|mostra/nascondi la barra compatta|mostrar/ocultar barra compacta|간략 막대 표시/숨기기|显示/隐藏紧凑栏|顯示/隱藏精簡列
HELP_COPY|ouvrir un rapport de diagnostic à copier|abrir informe de diagnóstico para copiar|apri un rapporto diagnostico da copiare|abrir relatório de diagnóstico para copiar|복사 가능한 진단 보고서 열기|打开可复制的诊断报告|開啟可複製的診斷報告
HELP_HEADER|Disenchantry — commandes :|Disenchantry — comandos:|Disenchantry — comandi:|Disenchantry — comandos:|Disenchantry — 명령어:|Disenchantry — 命令：|Disenchantry — 指令：
HELP_MINIMAP|afficher/masquer/réinitialiser le bouton de minicarte|mostrar/ocultar/restablecer botón del minimapa|mostra/nascondi/ripristina il pulsante della minimappa|mostrar/ocultar/redefinir botão do minimapa|미니맵 버튼 표시/숨기기/초기화|显示/隐藏/重置小地图按钮|顯示/隱藏/重設小地圖按鈕
HELP_OPTIONS|ouvrir les paramètres|abrir ajustes|apri le impostazioni|abrir configurações|설정 열기|打开设置|開啟設定
HELP_REFRESH|actualiser le contenu des sacs|volver a escanear las bolsas|riesamina le borse|examinar bolsas novamente|가방 다시 검색|重新扫描背包|重新掃描背包
HELP_TOGGLE|ouvrir/fermer la fenêtre|abrir/cerrar ventana|apri/chiudi la finestra|abrir/fechar janela|창 열기/닫기|打开/关闭窗口|開啟/關閉視窗
HOTKEY_CLEAR|Effacer|Borrar|Cancella|Limpar|지우기|清除|清除
HOTKEY_HINT|Traite un objet en attente lorsque la fenêtre est ouverte en mode désenchantement. Remplace alors l'action de la touche. Ctrl/Alt/Maj acceptés. Enregistrement automatique.|Procesa un objeto de la cola con la ventana abierta en modo desencantamiento. Sustituye la acción de la tecla mientras está abierta. Admite Ctrl/Alt/Mayús. Se guarda automáticamente.|Elabora un oggetto in coda mentre la finestra è aperta in modalità disincantamento. Sostituisce temporaneamente l'azione del tasto. Supporta Ctrl/Alt/Maiusc. Salvataggio automatico.|Processa um item da fila com a janela aberta no modo desencantamento. Substitui a ação da tecla enquanto aberta. Aceita Ctrl/Alt/Shift. Salvo automaticamente.|마력 추출 모드의 창이 열려 있을 때 대기열 아이템 하나를 처리합니다. 창이 열린 동안 기존 키 동작을 대체합니다. Ctrl/Alt/Shift 지원. 자동 저장됩니다.|分解模式窗口打开时，处理队列中的一件物品，并暂时覆盖按键原有功能。支持Ctrl/Alt/Shift。自动保存。|分解模式視窗開啟時，處理佇列中的一件物品，並暫時取代按鍵原有功能。支援Ctrl/Alt/Shift。自動儲存。
HOTKEY_PRESS|Appuyez sur une touche (Échap : annuler)|Pulsa una tecla (Esc cancela)|Premi un tasto (Esc annulla)|Pressione uma tecla (Esc cancela)|키를 누르세요 (Esc 취소)|请按键（Esc取消）|請按鍵（Esc取消）
HOTKEY_SET|Cliquer pour assigner|Clic para asignar|Clic per assegnare|Clique para atribuir|클릭하여 지정|点击绑定|點擊綁定
HOTKEY_TITLE|Raccourci de désenchantement|Tecla de desencantamiento|Tasto di disincantamento|Tecla de desencantamento|마력 추출 단축키|分解快捷键|分解快捷鍵
ILVL_BELOW|File auto : niveau inférieur à :|Encolar solo objetos de nivel inferior a:|Accoda solo oggetti di livello inferiore a:|Enfileirar apenas itens abaixo do nível:|자동 대기열 아이템 레벨 상한:|仅自动加入低于此等级的物品：|僅自動加入低於此等級的物品：
ILVL_CAP_EMPTY|Protection par niveau active, mais aucun niveau défini ! Saisissez un niveau ou désactivez la protection.|¡Protección por nivel activa sin límite definido! Introduce un nivel o desactívala.|Protezione per livello attiva, ma nessun livello impostato! Inserisci un livello o disattivala.|Proteção por nível ativa, mas sem nível definido! Digite um nível ou desative-a.|아이템 레벨 보호가 켜져 있지만 레벨이 설정되지 않았습니다. 레벨을 입력하거나 보호를 끄세요.|已启用物品等级保护，但未设置等级！请输入等级或关闭保护。|已啟用物品等級保護，但未設定等級！請輸入等級或關閉保護。
ILVL_HINT|Suggestion : le niveau le plus bas de votre équipement. Ce n'est qu'un repère. Les objets protégés peuvent être sélectionnés manuellement.|Sugerencia: el nivel más bajo de tu equipo. Es solo una referencia. Los objetos protegidos se pueden seleccionar manualmente.|Suggerimento: il livello più basso dell'equipaggiamento indossato. È solo un riferimento. Puoi selezionare manualmente gli oggetti protetti.|Sugestão: o menor nível do equipamento vestido. É apenas uma referência. Itens protegidos podem ser selecionados manualmente.|제안값은 착용 중인 장비의 최저 레벨이며 참고용입니다. 보호된 아이템도 수동으로 선택할 수 있습니다.|建议值为已装备物品中的最低等级，仅供参考。受保护物品仍可手动选择。|建議值為已裝備物品中的最低等級，僅供參考。受保護物品仍可手動選取。
ILVL_PROTECT|Protection par niveau dans la file auto|Protección por nivel en cola automática|Protezione per livello nella coda automatica|Proteção por nível na fila automática|자동 대기열 아이템 레벨 보호|自动队列物品等级保护|自動佇列物品等級保護
ILVL_SUGGEST|Suggérer|Sugerir|Suggerisci|Sugerir|추천|建议|建議
LANGUAGE|Langue de l'addon|Idioma del addon|Lingua dell'addon|Idioma do addon|애드온 언어|插件语言|插件語言
LANGUAGE_APPLY|Appliquer et recharger|Aplicar y recargar|Applica e ricarica|Aplicar e recarregar|적용 후 재시작|应用并重载|套用並重載
LANGUAGE_AUTO|Automatique|Automático|Automatico|Automático|자동|自动|自動
LANGUAGE_HINT|L'addon utilise automatiquement la langue actuelle du client de jeu.|El addon usa automáticamente el idioma actual del cliente del juego.|L'addon usa automaticamente la lingua attuale del client di gioco.|O addon usa automaticamente o idioma atual do cliente do jogo.|애드온은 현재 게임 클라이언트 언어를 자동으로 사용합니다.|插件自动使用当前游戏客户端的语言。|插件自動使用目前遊戲客戶端的語言。
LIST_REFRESHED|Liste actualisée.|Lista actualizada.|Elenco aggiornato.|Lista atualizada.|목록을 갱신했습니다.|列表已刷新。|清單已更新。
MILL|Moudre|Moler|Macina|Triturar|제분|研磨|研磨
MILL_COUNT|Moudre (%d)|Moler (%d)|Macina (%d)|Triturar (%d)|제분 (%d)|研磨（%d）|研磨（%d）
MINIMAP_SHOW_OPTION|Afficher le bouton de minicarte|Mostrar botón del minimapa|Mostra pulsante minimappa|Mostrar botão do minimapa|미니맵 버튼 표시|显示小地图按钮|顯示小地圖按鈕
MM_ALT_HIDE|Alt+clic : masquer le bouton|Alt+clic: ocultar botón|Alt+clic: nascondi pulsante|Alt+clique: ocultar botão|Alt+클릭: 버튼 숨기기|Alt+点击：隐藏按钮|Alt+點擊：隱藏按鈕
MM_COMPACT_HINT|/ed compact : barre compacte|/ed compact alterna la barra compacta|/ed compact attiva la barra compatta|/ed compact alterna a barra compacta|/ed compact: 간략 막대 전환|/ed compact切换紧凑栏|/ed compact切換精簡列
MM_DRAG|Glisser : déplacer le bouton|Arrastrar: mover botón|Trascina: sposta pulsante|Arrastar: mover botão|드래그: 버튼 이동|拖动：移动按钮|拖曳：移動按鈕
MM_HIDDEN|Bouton masqué. /ed show pour le réafficher.|Botón oculto. /ed show para mostrarlo.|Pulsante nascosto. /ed show per mostrarlo.|Botão oculto. /ed show para exibir.|버튼을 숨겼습니다. /ed show로 다시 표시합니다.|按钮已隐藏。输入/ed show恢复。|按鈕已隱藏。輸入/ed show恢復。
MM_LEFT|Clic gauche : ouvrir/fermer|Clic izquierdo: abrir/cerrar|Clic sinistro: apri/chiudi|Clique esquerdo: abrir/fechar|좌클릭: 창 열기/닫기|左键：打开/关闭窗口|左鍵：開啟/關閉視窗
MM_RESET|Position du bouton réinitialisée.|Posición del botón restablecida.|Posizione del pulsante ripristinata.|Posição do botão redefinida.|버튼 위치를 초기화했습니다.|按钮位置已重置。|按鈕位置已重設。
MM_RIGHT|Clic droit : paramètres|Clic derecho: ajustes|Clic destro: impostazioni|Clique direito: configurações|우클릭: 설정|右键：设置|右鍵：設定
MM_SHOWN|Bouton de minicarte affiché.|Botón del minimapa visible.|Pulsante minimappa visibile.|Botão do minimapa visível.|미니맵 버튼을 표시했습니다.|已显示小地图按钮。|已顯示小地圖按鈕。
MODE_CHANGE_IN_COMBAT|Impossible de changer de mode en combat.|No se puede cambiar de modo en combate.|Impossibile cambiare modalità in combattimento.|Não é possível mudar de modo em combate.|전투 중에는 모드를 변경할 수 없습니다.|战斗中无法切换模式。|戰鬥中無法切換模式。
MODE_DISENCHANT|Désenchantement|Desencantamiento|Disincantamento|Desencantamento|마력 추출|分解|分解
MODE_MILLING|Mouture|Molienda|Macinazione|Trituração|제분|研磨|研磨
MODE_NOT_LEARNED_HINT|Compétence de métier non apprise|Habilidad de profesión no aprendida|Abilità della professione non appresa|Habilidade de profissão não aprendida|전문 기술 능력을 배우지 않음|尚未学习专业技能|尚未學習專業技能
MODE_NO_PROTECTION_SETTINGS|Aucun paramètre de protection pour ce mode.|No hay ajustes de protección para este modo.|Nessuna impostazione di protezione per questa modalità.|Não há configurações de proteção para este modo.|이 모드에는 보호 설정이 없습니다.|此模式无保护设置。|此模式無保護設定。
MODE_PROSPECTING|Prospection|Prospección|Prospezione|Prospecção|보석 추출|选矿|勘探
MODE_SWITCH_HINT|Choisir le mode de traitement|Elegir modo de procesamiento|Scegli modalità di lavorazione|Escolher modo de processamento|처리 모드 선택|选择处理模式|選擇處理模式
NOT_IN_COMBAT|Indisponible en combat.|No disponible en combate.|Non disponibile in combattimento.|Indisponível em combate.|전투 중에는 사용할 수 없습니다.|战斗中不可用。|戰鬥中不可用。
NO_QUEUE_ITEM|Aucun objet sélectionné dans la file.|Ningún objeto seleccionado en la cola.|Nessun oggetto selezionato in coda.|Nenhum item selecionado na fila.|대기열에서 선택한 아이템이 없습니다.|队列中未选择物品。|佇列中未選取物品。
OPEN_BLACKLIST|Ouvrir les exclusions|Abrir exclusiones|Apri esclusioni|Abrir exclusões|제외 목록 열기|打开排除列表|開啟排除清單
PRICE_AT_LEAST|Protéger les objets valant au moins :|Proteger objetos con valor mínimo de:|Proteggi oggetti con valore minimo di:|Proteger itens com valor mínimo de:|이 가격 이상인 아이템 보호:|保护价值不低于此金额的物品：|保護價值不低於此金額的物品：
PRICE_GOLD|or|oro|oro|ouro|골드|金币|金幣
PRICE_HINT|La file auto ignore les objets de cette valeur ou plus, ainsi que ceux sans prix connu. La sélection manuelle reste possible. Nécessite TSM ou Auctionator.|La cola automática omite objetos de este valor o superior y aquellos sin precio conocido. Se pueden seleccionar manualmente. Requiere TSM o Auctionator.|La coda automatica salta gli oggetti di questo valore o superiore e quelli senza prezzo noto. Puoi selezionarli manualmente. Richiede TSM o Auctionator.|A fila automática ignora itens desse valor ou superior e itens sem preço conhecido. A seleção manual continua disponível. Requer TSM ou Auctionator.|자동 대기열은 이 가격 이상의 아이템과 가격을 알 수 없는 아이템을 건너뜁니다. 수동 선택은 가능합니다. TSM 또는 Auctionator가 필요합니다.|自动队列跳过达到此价值及以上的物品，以及价格未知的物品。仍可手动选择。需要TSM或Auctionator。|自動佇列略過達到此價值及以上的物品，以及價格未知的物品。仍可手動選取。需要TSM或Auctionator。
PRICE_PROTECT|Protection de valeur dans la file auto|Protección por valor en cola automática|Protezione del valore nella coda automatica|Proteção de valor na fila automática|자동 대기열 고가 아이템 보호|自动队列高价值物品保护|自動佇列高價值物品保護
PRICE_THRESHOLD_EMPTY|Protection de valeur active, mais aucun montant défini ! Saisissez un montant ou désactivez la protection.|¡Protección por valor activa sin importe definido! Introduce un importe o desactívala.|Protezione del valore attiva, ma nessun importo impostato! Inserisci un importo o disattivala.|Proteção de valor ativa, mas sem valor definido! Digite um valor ou desative-a.|가격 보호가 켜져 있지만 금액이 설정되지 않았습니다. 금액을 입력하거나 보호를 끄세요.|已启用价值保护，但未设置金额！请输入金额或关闭保护。|已啟用價值保護，但未設定金額！請輸入金額或關閉保護。
PROSPECT|Prospecter|Prospectar|Prospetta|Prospectar|보석 추출|选矿|勘探
PROSPECT_COUNT|Prospecter (%d)|Prospectar (%d)|Prospetta (%d)|Prospectar (%d)|보석 추출 (%d)|选矿（%d）|勘探（%d）
]=])
rows([=[
QUALITY_2|Inhabituel|Poco común|Non comune|Incomum|고급|优秀|優良
QUALITY_3|Rare|Raro|Raro|Raro|희귀|精良|精良
QUALITY_4|Épique|Épico|Epico|Épico|영웅|史诗|史詩
QUALITY_HEADER|Afficher ces qualités :|Mostrar estas calidades:|Mostra queste qualità:|Mostrar estas qualidades:|목록에 표시할 품질:|显示以下品质的物品：|顯示以下品質的物品：
QUEUE_EMPTY|Aucun objet sélectionné|Ningún objeto seleccionado|Nessun oggetto selezionato|Nenhum item selecionado|선택한 아이템 없음|未选择物品|未選取物品
QUEUE_IN_COMBAT|Verrouillé en combat|Bloqueado en combate|Bloccato in combattimento|Bloqueado em combate|전투 중 잠김|战斗中锁定|戰鬥中鎖定
QUEUE_NEXT|Suivant : %s|Siguiente: %s|Prossimo: %s|Próximo: %s|다음: %s|下一个：%s|下一個：%s
QUEUE_NOT_LEARNED|Désenchantement non appris|Desencantamiento no aprendido|Disincantamento non appreso|Desencantamento não aprendido|마력 추출을 배우지 않음|尚未学习分解|尚未學習分解
QUEUE_TITLE|File d'attente|Cola|Coda|Fila|대기열|队列|佇列
REFRESH|Actualiser|Actualizar|Aggiorna|Atualizar|새로 고침|刷新|更新
REMOVED_FROM_BLACKLIST|Retiré des exclusions : %s|Quitado de exclusiones: %s|Rimosso dalle esclusioni: %s|Removido das exclusões: %s|제외 목록에서 제거: %s|已从排除列表移除：%s|已從排除清單移除：%s
SELECT_ALL|Tout choisir|Elegir todo|Seleziona tutto|Selecionar tudo|모두 선택|全选|全選
SETTINGS_BUTTON|Options|Opciones|Opzioni|Opções|설정|设置|設定
SETTINGS_TITLE|Paramètres|Ajustes|Impostazioni|Configurações|설정|设置|設定
SKIP_BUTTON|Ignorer|Omitir|Salta|Ignorar|건너뛰기|跳过|略過
SKIP_HINT|Ignorer cet objet jusqu'à la fermeture de la fenêtre de l'addon.|Omitir este objeto hasta cerrar la ventana del addon.|Salta questo oggetto fino alla chiusura della finestra dell'addon.|Ignorar este item até fechar a janela do addon.|애드온 창을 닫을 때까지 이 아이템을 건너뜁니다.|在关闭插件窗口前跳过此物品。|在關閉插件視窗前略過此物品。
STATS_AH_ITEMS|Valeur des objets à l'HV :|Valor de objetos en subasta:|Valore oggetti all'asta:|Valor dos itens no leilão:|아이템 경매장 가치:|物品拍卖价值：|物品拍賣價值：
STATS_AH_MATERIALS|Valeur des matériaux à l'HV :|Valor de materiales en subasta:|Valore materiali all'asta:|Valor dos materiais no leilão:|재료 경매장 가치:|材料拍卖价值：|材料拍賣價值：
STATS_BASIS_AH|Comparer : hôtel des ventes|Comparar con: subasta|Confronta con: asta|Comparar com: leilão|비교 기준: 경매장|比较基准：拍卖行|比較基準：拍賣場
STATS_BASIS_VENDOR|Comparer : marchand|Comparar con: vendedor|Confronta con: mercante|Comparar com: vendedor|비교 기준: 상인|比较基准：商人|比較基準：商人
STATS_BUTTON|Statistiques|Estadísticas|Statistiche|Estatísticas|통계|统计|統計
STATS_COUNT|Quantité|Cantidad|Quantità|Quantidade|수량|数量|數量
STATS_EMPTY|Aucun matériau reçu pour l'instant.|Aún no se han recibido materiales.|Nessun materiale ancora ricevuto.|Nenhum material recebido ainda.|아직 획득한 재료가 없습니다.|尚未获得材料。|尚未獲得材料。
STATS_ESTIMATE|Les prix d'enchères sont estimatifs. Statistiques par personnage.|Los precios de subasta son estimaciones. Estadísticas por personaje.|I prezzi d'asta sono stime. Statistiche per personaggio.|Os preços de leilão são estimativas. Estatísticas por personagem.|경매장 가격은 추정치입니다. 통계는 캐릭터별로 집계됩니다.|拍卖价格为估值。统计按角色分别记录。|拍賣價格為估值。統計按角色分別記錄。
STATS_INCOMPLETE|Estimation incomplète : certains prix sont indisponibles.|Estimación incompleta: faltan algunos precios.|Stima incompleta: alcuni prezzi non sono disponibili.|Estimativa incompleta: alguns preços indisponíveis.|불완전한 추정치: 일부 가격을 알 수 없습니다.|估值不完整：部分价格未知。|估值不完整：部分價格未知。
STATS_LOSS|Perte :|Pérdida:|Perdita:|Prejuízo:|손실:|亏损：|虧損：
STATS_MATERIALS|Matériaux reçus|Materiales recibidos|Materiali ricevuti|Materiais recebidos|획득한 재료|获得的材料|獲得的材料
STATS_OVERVIEW|Désenchantés : %d\nTotal marchand : %s\nLe plus cher : %s|Desencantados: %d\nTotal vendedor: %s\nMás caro: %s|Disincantati: %d\nTotale mercante: %s\nPiù costoso: %s|Desencantados: %d\nTotal no vendedor: %s\nMais caro: %s|마력 추출: %d\n상인 판매 총액: %s\n최고가: %s|已分解：%d\n商人售价总计：%s\n最贵物品：%s|已分解：%d\n商人售價總計：%s\n最貴物品：%s
STATS_PROFIT|Bénéfice :|Beneficio:|Profitto:|Lucro:|이익:|利润：|利潤：
STATS_QUALITY|Qualité des objets :|Calidad del objeto:|Qualità oggetto:|Qualidade do item:|아이템 품질:|物品品质：|物品品質：
STATS_RESET|Réinitialiser|Reiniciar sesión|Azzera sessione|Zerar sessão|세션 초기화|重置本次统计|重設本次統計
STATS_SESSION|Session|Sesión|Sessione|Sessão|이번 세션|本次|本次
STATS_TOTAL|Total cumulé|Histórico|Totale storico|Histórico|전체 기간|累计|累計
STATS_UNIT|Prix unitaire|Precio unitario|Prezzo unitario|Preço unitário|개당 가격|单价|單價
STATS_VALUE|Total|Total|Totale|Total|합계|总计|總計
STATUS_IN_COMBAT|Verrouillé en combat.|Bloqueado en combate.|Bloccato in combattimento.|Bloqueado em combate.|전투 중 잠겨 있습니다.|战斗中锁定。|戰鬥中鎖定。
STATUS_NOT_LEARNED|Ce personnage n'a pas appris le désenchantement.|Este personaje no ha aprendido desencantamiento.|Questo personaggio non ha appreso il disincantamento.|Este personagem não aprendeu desencantamento.|이 캐릭터는 마력 추출을 배우지 않았습니다.|此角色尚未学习分解。|此角色尚未學習分解。
SUBTITLE|Sélectionnez des objets, puis cliquez sur Désenchanter une fois par objet|Selecciona objetos y pulsa Desencantar una vez por objeto|Seleziona gli oggetti, poi premi Disincanta una volta per oggetto|Selecione itens e clique em Desencantar uma vez por item|아이템을 선택하고 아이템마다 마력 추출을 한 번씩 누르세요|选择物品，每次点击“分解”处理一件物品|選取物品，每次點擊「分解」處理一件物品
SUBTITLE_MILLING|Sélectionnez les plantes à moudre|Selecciona las hierbas que quieras moler|Seleziona le erbe da macinare|Selecione as ervas para triturar|제분할 약초를 선택하세요|选择要研磨的草药|選取要研磨的草藥
SUBTITLE_PROSPECTING|Sélectionnez les minerais à prospecter|Selecciona los minerales que quieras prospectar|Seleziona i minerali da prospettare|Selecione os minérios para prospectar|보석 추출할 광석을 선택하세요|选择要选矿的矿石|選取要勘探的礦石
UNKNOWN|Inconnu|Desconocido|Sconosciuto|Desconhecido|알 수 없음|未知|未知
UNKNOWN_ITEM|Objet inconnu|Objeto desconocido|Oggetto sconosciuto|Item desconhecido|알 수 없는 아이템|未知物品|未知物品
VALUE_TOOLTIP|Valeur marchande : %s (%s)|Valor de mercado: %s (%s)|Valore di mercato: %s (%s)|Valor de mercado: %s (%s)|시장 가치: %s (%s)|市场价值：%s（%s）|市場價值：%s（%s）
]=])
-- Diagnostic labels are also user-visible. API identifiers remain unchanged.
rows([=[
DIAG_CLIENT|Client|Client|Клиент|Client|Cliente|Client|Cliente|클라이언트|客户端|客戶端
DIAG_LOCALE|Locale|Sprache|Язык|Langue|Idioma|Lingua|Idioma|언어|语言|語言
DIAG_LIBRARIES|Library registry|Bibliotheksregister|Реестр библиотек|Registre des bibliothèques|Registro de bibliotecas|Registro librerie|Registro de bibliotecas|라이브러리 등록|库注册表|程式庫登錄
DIAG_BROKER|Launcher broker|Starter-Broker|Брокер кнопки запуска|Courtier du lanceur|Broker del lanzador|Broker di avvio|Broker de inicialização|실행 버튼 브로커|启动按钮代理|啟動按鈕代理
DIAG_MINIMAP|Minimap library|Minimap-Bibliothek|Библиотека миникарты|Bibliothèque de minicarte|Biblioteca del minimapa|Libreria minimappa|Biblioteca do minimapa|미니맵 라이브러리|小地图库|小地圖程式庫
DIAG_BAGS|Bag API|Taschen-API|API сумок|API des sacs|API de bolsas|API borse|API de bolsas|가방 API|背包API|背包API
DIAG_EQUIPMENT|Equipment API|Ausrüstungs-API|API экипировки|API d'équipement|API de equipo|API equipaggiamento|API de equipamento|장비 API|装备API|裝備API
DIAG_IDENTITY|Item identity|Gegenstandskennung|Идентификация предметов|Identification des objets|Identificación de objetos|Identificazione oggetti|Identificação de itens|아이템 식별|物品识别|物品識別
DIAG_SLOT_FALLBACK|Bag/slot fallback|Tasche/Platz als Ersatz|Резервно: сумка/ячейка|Repli sur sac/emplacement|Alternativa: bolsa/ranura|Alternativa: borsa/scomparto|Alternativa: bolsa/espaço|대체 식별: 가방/칸|备用：背包/格位|備用：背包/欄位
DIAG_COVERAGE|Bag coverage|Erfasste Taschen|Охват сумок|Sacs couverts|Bolsas incluidas|Borse incluse|Bolsas incluídas|가방 검색 범위|背包扫描范围|背包掃描範圍
DIAG_BAG_DETAIL|Containers: %d; reagent bag: %s|Behälter: %d; Reagenzientasche: %s|Контейнеров: %d; сумка реагентов: %s|Conteneurs : %d ; sac de composants : %s|Contenedores: %d; bolsa de componentes: %s|Contenitori: %d; borsa reagenti: %s|Recipientes: %d; bolsa de reagentes: %s|가방: %d; 재료 가방: %s|容器：%d；材料包：%s|容器：%d；材料包：%s
DIAG_PROTECTION|Protection settings|Schutzeinstellungen|Настройки защиты|Paramètres de protection|Ajustes de protección|Impostazioni protezione|Configurações de proteção|보호 설정|保护设置|保護設定
DIAG_PROTECTION_DETAIL|Level: %s/%s; exclusions: %d; compact: %s|Stufe: %s/%s; Ausschlüsse: %d; kompakt: %s|Уровень: %s/%s; исключений: %d; компактный: %s|Niveau : %s/%s ; exclusions : %d ; compact : %s|Nivel: %s/%s; exclusiones: %d; compacto: %s|Livello: %s/%s; esclusioni: %d; compatto: %s|Nível: %s/%s; exclusões: %d; compacto: %s|레벨: %s/%s; 제외: %d; 간략: %s|等级：%s/%s；排除数：%d；紧凑：%s|等級：%s/%s；排除數：%d；精簡：%s
DIAG_MARKET|Market data|Marktdaten|Рыночные данные|Données du marché|Datos de mercado|Dati di mercato|Dados de mercado|시장 데이터|市场数据|市場資料
DIAG_NO_SOURCE|No source|Keine Quelle|Нет источника|Aucune source|Sin fuente|Nessuna fonte|Sem fonte|출처 없음|无来源|無來源
DIAG_THRESHOLD|Threshold: %s|Schwelle: %s|Порог: %s|Seuil : %s|Umbral: %s|Soglia: %s|Limite: %s|기준값: %s|阈值：%s|門檻：%s
DIAG_PROFESSIONS|Profession support|Berufsunterstützung|Поддержка профессий|Métiers pris en charge|Profesiones compatibles|Professioni supportate|Profissões compatíveis|전문 기술 지원|专业支持|專業支援
DIAG_SPELL|Spell: %s|Zauber: %s|Заклинание: %s|Sort : %s|Hechizo: %s|Incantesimo: %s|Feitiço: %s|주문: %s|法术：%s|法術：%s
DIAG_LEARNED|Learned profession|Erlernter Beruf|Изученная профессия|Métier appris|Profesión aprendida|Professione appresa|Profissão aprendida|배운 전문 기술|已学专业|已學專業
DIAG_CLICKS|Click registration|Klickregistrierung|Регистрация нажатия|Enregistrement des clics|Registro de clics|Registrazione clic|Registro de cliques|클릭 등록|点击注册|點擊註冊
DIAG_REFRESH|Inventory refresh|Inventaraktualisierung|Обновление инвентаря|Actualisation de l'inventaire|Actualización de inventario|Aggiornamento inventario|Atualização do inventário|소지품 갱신|背包刷新|背包更新
DIAG_DEFERRED|Deferred during combat|Im Kampf aufgeschoben|Отложено до конца боя|Différé pendant le combat|Pospuesto durante el combate|Rimandato durante il combattimento|Adiado durante o combate|전투 종료 후 처리|延后至战斗结束|延後至戰鬥結束
DIAG_CANDIDATES|Candidates: %d; queued: %d|Kandidaten: %d; eingereiht: %d|Подходящих: %d; в очереди: %d|Candidats : %d ; en attente : %d|Candidatos: %d; en cola: %d|Candidati: %d; in coda: %d|Candidatos: %d; na fila: %d|대상: %d; 대기열: %d|候选：%d；已入队：%d|候選：%d；已入列：%d
DIAG_TARGET|Action target|Aktionsziel|Цель действия|Cible de l'action|Objetivo de acción|Bersaglio azione|Alvo da ação|동작 대상|操作目标|操作目標
DIAG_HEADER|Disenchantry diagnostics|Disenchantry-Diagnose|Диагностика Disenchantry|Diagnostic Disenchantry|Diagnóstico de Disenchantry|Diagnostica Disenchantry|Diagnóstico do Disenchantry|Disenchantry 진단|Disenchantry诊断|Disenchantry診斷
DIAG_OK|OK|OK|УСПЕХ|OK|CORRECTO|OK|OK|정상|正常|正常
DIAG_FAIL|FAIL|FEHLER|ОШИБКА|ÉCHEC|ERROR|ERRORE|FALHA|실패|失败|失敗
DIAG_ENABLED|Enabled|Aktiviert|Включено|Activé|Activado|Attivo|Ativado|켜짐|已启用|已啟用
DIAG_DISABLED|Disabled|Deaktiviert|Выключено|Désactivé|Desactivado|Disattivo|Desativado|꺼짐|已禁用|已停用
ITEM_LEVEL_SHORT|ilvl %d|GS %d|ур. %d|niv. %d|niv. %d|liv. %d|nív. %d|레벨 %d|装等%d|裝等%d
BIND_ACCOUNT_SHORT|WB|Kdg.|Отряд|Compte|Cuenta|Account|Conta|계정|战团|戰隊
BIND_EQUIP_SHORT|BoE|B. Anl.|БоЕ|LqE|Equipar|Equip.|Equipar|착귀|装绑|裝綁
BIND_PICKUP_SHORT|BoP|B. Aufh.|Перс.|LqR|Recoger|Racc.|Pegar|획귀|拾绑|拾綁
]=], {"enUS", "deDE", "ruRU", "frFR", "esES", "itIT", "ptBR", "koKR", "zhCN", "zhTW"})

end
LoadComponent("ForeverTools", FT.disenchantry)
