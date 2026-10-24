# -*- coding: utf-8 -*-
"""Generate a polished RTL Word report for the consignment system."""
from pathlib import Path

from docx import Document
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor

OUT = Path(__file__).resolve().parents[1] / "docs" / "SYSTEM_REPORT.docx"
OUT_DESKTOP = Path.home() / "Desktop" / "تقرير_آلية_عمل_نظام_الكمسيون.docx"

# Colors
NAVY = RGBColor(0x0E, 0x4D, 0x64)
TEAL = RGBColor(0x0E, 0x80, 0x88)
DARK = RGBColor(0x1F, 0x29, 0x37)
MUTED = RGBColor(0x4B, 0x55, 0x63)
WHITE = RGBColor(0xFF, 0xFF, 0xFF)
HEADER_BG = "0E8088"
ALT_ROW = "E8F6F7"
CALLOUT_BG = "FFF8E7"
CALLOUT_BORDER = "D6B656"


def set_rtl_paragraph(p):
    p.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    pPr = p._p.get_or_add_pPr()
    bidi = OxmlElement("w:bidi")
    bidi.set(qn("w:val"), "1")
    pPr.append(bidi)


def set_run_font(run, size=11, bold=False, color=DARK, font_name="Calibri"):
    run.bold = bold
    run.font.size = Pt(size)
    run.font.color.rgb = color
    run.font.name = font_name
    r = run._element
    rPr = r.get_or_add_rPr()
    rFonts = rPr.find(qn("w:rFonts"))
    if rFonts is None:
        rFonts = OxmlElement("w:rFonts")
        rPr.append(rFonts)
    rFonts.set(qn("w:ascii"), font_name)
    rFonts.set(qn("w:hAnsi"), font_name)
    rFonts.set(qn("w:cs"), "Arial")


def shade_cell(cell, hex_color):
    tc = cell._tePr if hasattr(cell, "_tePr") else cell._tc
    tcPr = tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:fill"), hex_color)
    shd.set(qn("w:val"), "clear")
    tcPr.append(shd)


def set_cell_borders(cell, color="CCCCCC"):
    tc = cell._tc
    tcPr = tc.get_or_add_tcPr()
    borders = OxmlElement("w:tcBorders")
    for edge in ("top", "left", "bottom", "right"):
        el = OxmlElement(f"w:{edge}")
        el.set(qn("w:val"), "single")
        el.set(qn("w:sz"), "4")
        el.set(qn("w:color"), color)
        borders.append(el)
    tcPr.append(borders)


def add_paragraph(doc, text, size=11, bold=False, color=DARK, space_after=6, space_before=0):
    p = doc.add_paragraph()
    set_rtl_paragraph(p)
    p.paragraph_format.space_after = Pt(space_after)
    p.paragraph_format.space_before = Pt(space_before)
    p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.ONE_POINT_FIVE
    run = p.add_run(text)
    set_run_font(run, size=size, bold=bold, color=color)
    return p


def add_heading_custom(doc, text, level=1):
    p = doc.add_paragraph()
    set_rtl_paragraph(p)
    if level == 1:
        p.paragraph_format.space_before = Pt(18)
        p.paragraph_format.space_after = Pt(10)
        run = p.add_run(text)
        set_run_font(run, size=16, bold=True, color=NAVY)
        # underline bar via bottom border on paragraph
        pPr = p._p.get_or_add_pPr()
        pBdr = OxmlElement("w:pBdr")
        bottom = OxmlElement("w:bottom")
        bottom.set(qn("w:val"), "single")
        bottom.set(qn("w:sz"), "12")
        bottom.set(qn("w:space"), "4")
        bottom.set(qn("w:color"), "0E8088")
        pBdr.append(bottom)
        pPr.append(pBdr)
    else:
        p.paragraph_format.space_before = Pt(12)
        p.paragraph_format.space_after = Pt(6)
        run = p.add_run(text)
        set_run_font(run, size=13, bold=True, color=TEAL)
    return p


def add_bullets(doc, items, size=11):
    for item in items:
        p = doc.add_paragraph(style="List Bullet")
        set_rtl_paragraph(p)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.ONE_POINT_FIVE
        # clear default runs and add ours
        if p.runs:
            p.runs[0].text = item
            set_run_font(p.runs[0], size=size, color=DARK)
        else:
            run = p.add_run(item)
            set_run_font(run, size=size, color=DARK)


def add_numbered(doc, items, size=11):
    for item in items:
        p = doc.add_paragraph(style="List Number")
        set_rtl_paragraph(p)
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.ONE_POINT_FIVE
        if p.runs:
            p.runs[0].text = item
            set_run_font(p.runs[0], size=size, color=DARK)
        else:
            run = p.add_run(item)
            set_run_font(run, size=size, color=DARK)


def add_table(doc, headers, rows):
    table = doc.add_table(rows=1 + len(rows), cols=len(headers))
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = True

    for i, h in enumerate(headers):
        cell = table.rows[0].cells[i]
        cell.text = ""
        p = cell.paragraphs[0]
        set_rtl_paragraph(p)
        run = p.add_run(h)
        set_run_font(run, size=10, bold=True, color=WHITE)
        shade_cell(cell, HEADER_BG)
        set_cell_borders(cell, "0E8088")

    for r_idx, row in enumerate(rows):
        for c_idx, val in enumerate(row):
            cell = table.rows[r_idx + 1].cells[c_idx]
            cell.text = ""
            p = cell.paragraphs[0]
            set_rtl_paragraph(p)
            run = p.add_run(str(val))
            set_run_font(run, size=10, color=DARK)
            if r_idx % 2 == 1:
                shade_cell(cell, ALT_ROW)
            set_cell_borders(cell, "D0E8EA")

    doc.add_paragraph()
    return table


def add_callout(doc, title, body):
    table = doc.add_table(rows=1, cols=1)
    cell = table.rows[0].cells[0]
    shade_cell(cell, CALLOUT_BG)
    set_cell_borders(cell, CALLOUT_BORDER)
    cell.text = ""
    p1 = cell.paragraphs[0]
    set_rtl_paragraph(p1)
    r1 = p1.add_run(title)
    set_run_font(r1, size=11, bold=True, color=RGBColor(0x8A, 0x6D, 0x1D))
    p2 = cell.add_paragraph()
    set_rtl_paragraph(p2)
    r2 = p2.add_run(body)
    set_run_font(r2, size=10, color=DARK)
    doc.add_paragraph()


def add_flow_box(doc, lines):
    table = doc.add_table(rows=1, cols=1)
    cell = table.rows[0].cells[0]
    shade_cell(cell, "F0F9FA")
    set_cell_borders(cell, "0E8088")
    cell.text = ""
    first = True
    for line in lines:
        p = cell.paragraphs[0] if first else cell.add_paragraph()
        first = False
        set_rtl_paragraph(p)
        p.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(line)
        set_run_font(run, size=11, bold=True, color=NAVY)
    doc.add_paragraph()


def build():
    doc = Document()

    # Page setup — RTL-friendly margins
    section = doc.sections[0]
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.top_margin = Cm(1.8)
    section.bottom_margin = Cm(1.8)
    section.left_margin = Cm(2.0)
    section.right_margin = Cm(2.0)
    # Section bidi
    sectPr = section._sectPr
    bidi = OxmlElement("w:bidi")
    bidi.set(qn("w:val"), "1")
    sectPr.append(bidi)

    # —— Cover ——
    add_paragraph(doc, "تقرير تقني وتشغيلي", size=12, bold=True, color=TEAL, space_after=4)
    add_paragraph(
        doc,
        "آلية عمل نظام محاسبة متاجر الكمسيون\n(البيع بالعمولة / Consignment)",
        size=22,
        bold=True,
        color=NAVY,
        space_after=12,
    )
    add_paragraph(
        doc,
        "شرح مبسّط وشامل لكيفية عمل النظام من الفكرة التجارية حتى الدفتر والتسويات",
        size=12,
        color=MUTED,
        space_after=16,
    )

    add_table(
        doc,
        ["البند", "القيمة"],
        [
            ["اسم المشروع", "Consignment Accounting System"],
            ["التقنيات", "React.js · Node.js / Express · Prisma 7 · MariaDB 11.8+"],
            ["نموذج العمل", "متعدد المستأجرين (SaaS) — متجر كمسيون لكل مستأجر"],
            ["العملة الافتراضية", "SYP (قابلة للتغيير لكل متجر)"],
        ],
    )

    add_callout(
        doc,
        "الفكرة في جملة واحدة",
        "المورد (غالباً مزارع) يضع بضاعته أمانة في المتجر. المتجر يبيعها مقابل عمولة، ولا يدفع للمورد إلا بعد البيع عبر تسوية محاسبية واضحة.",
    )

    # —— 1 ——
    add_heading_custom(doc, "1. الفكرة التجارية باختصار", 1)
    add_paragraph(
        doc,
        "النظام مخصّص لمتاجر تبيع منتجات موردين خارجيين دون أن تشتري البضاعة مسبقاً. البضاعة أمانة، والإيراد للمتجر هو العمولة فقط، والمستحق للمورد يُسجَّل ثم يُدفع لاحقاً.",
    )
    add_table(
        doc,
        ["المفهوم", "المعنى في النظام"],
        [
            ["البضاعة", "أمانة لدى المتجر، ملك للمورد حتى تُباع"],
            ["إيراد المتجر", "عمولة تُقتطع عند البيع (نسبة أو مبلغ ثابت)"],
            ["مستحق المورد", "صافي سعر البيع بعد العمولة — يُدفع في تسوية لاحقة"],
            ["المخزون", "دفعات استلام منفصلة لكل مورد/منتج"],
            ["اختيار الدفعة", "حرّ — ليس FIFO إلزامياً؛ يمكن بيع الأحدث وترك الأقدم"],
        ],
    )

    add_paragraph(doc, "دورة الحياة الأساسية:", bold=True, space_after=6)
    add_flow_box(
        doc,
        [
            "مورد يسلّم بضاعة  ←  المتجر يستلم (دفعة)",
            "↓",
            "كاشير يبيع للزبون (منتج / دفعة / سعر)",
            "↓",
            "تجميد العمولة + قيد في دفتر المورد + إنقاص الكمية",
            "↓",
            "تسوية دورية: إجمالي − خصومات = صافي يُدفع للمورد",
        ],
    )

    # —— 2 ——
    add_heading_custom(doc, "2. بنية المستأجرين (SaaS) والأدوار", 1)

    add_heading_custom(doc, "2.1 المتجر = مستأجر", 2)
    add_paragraph(
        doc,
        "كل متجر سجل مستقل (اسم، مالك، هاتف، عملة، حالة: تجريبي / نشط / معلّق / منتهٍ). كل البيانات التشغيلية مربوطة بـ tenant_id، والمفاتيح المركّبة تمنع خلط بيانات متجرين.",
    )

    add_heading_custom(doc, "2.2 الاشتراك والباقات", 2)
    add_bullets(
        doc,
        [
            "الباقات (plans): سعر، عملة، دورة فوترة، مزايا.",
            "الاشتراكات تحفظ لقطة من السعر والعملة عند الشراء حتى لا تتأثر الفواتير القديمة بتغيير الباقة.",
            "في التطبيق: منع تداخل اشتراكين، ومهمة تحوّل حالة المتجر إلى منتهٍ عند انتهاء الاشتراك.",
        ],
    )

    add_heading_custom(doc, "2.3 المستخدمون والأدوار", 2)
    add_table(
        doc,
        ["الدور", "المتجر (tenant)", "الاستخدام"],
        [
            ["super_admin", "بدون متجر (NULL)", "إدارة المنصة"],
            ["store_admin", "إلزامي", "إدارة المتجر"],
            ["cashier", "إلزامي", "نقطة البيع"],
            ["vendor", "إلزامي", "دخول اختياري للمورد إن رُبط حساب"],
        ],
    )
    add_paragraph(
        doc,
        "عمود tenant_scope (= رقم المتجر أو 0 للسوبر أدمن) يُحدَّث تلقائياً ويُستخدم في المفاتيح الأجنبية حتى لا يربط كاشير متجر أ بفاتورة متجر ب.",
        size=10,
        color=MUTED,
    )

    add_heading_custom(doc, "2.4 ملف المورد", 2)
    add_paragraph(
        doc,
        "بيانات المورد داخل المتجر (مزرعة، بنك، رقم حساب — يُفضَّل تشفيره). ربطه بحساب مستخدم اختياري: يمكن أن يعمل المورد بدون تسجيل دخول.",
    )

    # —— 3 ——
    add_heading_custom(doc, "3. الكتالوج: أصناف ومنتجات ووحدات", 1)
    add_bullets(
        doc,
        [
            "التصنيفات والمنتجات داخل كل متجر.",
            "لكل منتج سياسة عمولة افتراضية: نسبة أو ثابت، والثابت إما لكل وحدة أو مرة واحدة للبند.",
            "الوحدات (كيلو، صندوق، حبة…) تُسجَّل عند الاستلام والبيع.",
            "الحذف ناعم (deleted_at) مع إعادة تهيئة المفاتيح الفريدة حتى يمكن إعادة استخدام الاسم/الرابط.",
        ],
    )

    # —— 4 ——
    add_heading_custom(doc, "4. المخزون: الاستلام والدفعات والتعديلات", 1)

    add_heading_custom(doc, "4.1 استلام البضاعة", 2)
    add_numbered(
        doc,
        [
            "يُنشأ إيصال استلام لمورد معيّن ويستلمه موظف.",
            "لكل منتج في الإيصال «دفعة»: كمية مستلمة وكمية متبقية للبيع.",
            "الكمية المتبقية = المستلم − المبيعات + مرتجعات الزبون + تعديلات المخزون.",
        ],
    )

    add_callout(
        doc,
        "مهم: اختيار الدفعة حرّ (ليس FIFO)",
        "أي دفعة لنفس المنتج فيها كمية متبقية قابلة للبيع. الزبون قد يشتري من دفعة وصلت اليوم ويترك دفعة أقدم — وهذا مقصود في عمل متاجر الكمسيون مع المزارعين.",
    )

    add_heading_custom(doc, "4.3 تعديلات المخزون", 2)
    add_paragraph(
        doc,
        "التعديل رقم موقّع: السالب يقلّل المخزون (تالف −5)، والموجب يزيده (تصحيح +2). أسباب: تالف، إرجاع للمورد، منتهٍ، تصحيح. مرتجع الزبون مسار منفصل.",
    )

    # —— 5 ——
    add_heading_custom(doc, "5. البيع ونقطة البيع (POS)", 1)

    add_heading_custom(doc, "5.1 الفاتورة", 2)
    add_paragraph(
        doc,
        "رأس الفاتورة: كاشير من نفس المتجر، رقم فاتورة فريد، ومجاميع (إجمالي + عمولة المتجر + مستحق الموردين) يجب أن تتطابق. الحالة مكتملة أو ملغاة.",
    )

    add_callout(
        doc,
        "القاعدة الذهبية",
        "كل بند بيع = مورد واحد فقط. إن خُصّصت كميات من موردين مختلفين، يُقسَّم البيع إلى بنود في نقطة البيع. قاعدة البيانات ترفض خلط مورد البند مع دفعة استلام لمورد آخر.",
    )

    add_heading_custom(doc, "5.2 ما يُجمَّد عند البيع", 2)
    add_bullets(
        doc,
        [
            "السعر والكمية وإجمالي البند.",
            "نوع العمولة وقيمتها وأساسها (لقطة حتى لو تغيّر المنتج لاحقاً).",
            "حصة المتجر وحصة المورد — مجموعهما يساوي إجمالي البند.",
            "حالة التسوية: غير مسوّى أو مسوّى.",
        ],
    )

    add_heading_custom(doc, "5.3 مثال حساب عمولة نسبة", 2)
    add_numbered(
        doc,
        [
            "إجمالي البند = السعر × الكمية",
            "حصة المتجر = الإجمالي × (النسبة ÷ 100)",
            "حصة المورد = الإجمالي − حصة المتجر",
        ],
    )
    add_paragraph(
        doc,
        "للعمولة الثابتة: إما قيمة × الكمية (لكل وحدة) أو قيمة واحدة للبند. التقريب في التطبيق يجب أن يكون موحّداً دائماً.",
        size=10,
        color=MUTED,
    )

    add_heading_custom(doc, "5.4 خطوات معاملة البيع (في التطبيق)", 2)
    add_numbered(
        doc,
        [
            "قفل الدفعات المختارة داخل معاملة قاعدة بيانات.",
            "التحقق من كفاية الكمية المتبقية.",
            "إنشاء الفاتورة والبنود وتخصيصات الدفعات.",
            "إنقاص الكمية المتبقية.",
            "قيد دفتر (مستحق موجب) لكل مورد شارك في الفاتورة.",
            "تسجيل تدقيق عند الحاجة.",
        ],
    )

    add_heading_custom(doc, "5.5 إلغاء الفاتورة", 2)
    add_paragraph(
        doc,
        "إعادة الكميات، وقيود عكسية في الدفتر، وتعيين الحالة ملغاة. لا تُنشأ تسويات جديدة من فواتير ملغاة.",
    )

    # —— 6 ——
    add_heading_custom(doc, "6. مرتجعات الزبون", 1)
    add_paragraph(
        doc,
        "مسار مستقل عن «إرجاع البضاعة للمورد». المرتجع يرتبط بالفاتورة الأصلية ويعيد الكمية إلى نفس دفعات البيع (جزئياً أو كلياً)، مع قيد عكسي في دفتر المورد ينقص المستحق.",
    )
    add_numbered(
        doc,
        [
            "إنشاء مرتجع على فاتورة.",
            "تحديد البنود والكميات والمبالغ المعادة.",
            "توزيع الكمية على نفس دفعات التخصيص الأصلية.",
        ],
    )

    # —— 7 ——
    add_heading_custom(doc, "7. تسوية الموردين", 1)
    add_paragraph(
        doc,
        "التسوية تجمع بنود البيع غير المسوّاة لمورد واحد، ثم تطرح الخصومات (سلف، تالف، شحن…) لتصل إلى صافي يُدفع.",
    )
    add_table(
        doc,
        ["الحقل / الحالة", "المعنى"],
        [
            ["إجمالي (gross)", "مجموع حصص المورد من البنود المختارة"],
            ["خصومات (deductions)", "ما يُطرح من الإجمالي في هذه التسوية"],
            ["صافي (net)", "الإجمالي − الخصومات — يُدفع للمورد"],
            ["مسودة → مدفوعة", "عند الدفع يُسجَّل تاريخ الدفع وقيد في الدفتر"],
            ["إلغاء التسوية", "حذف بنودها وإعادة البنود لغير مسوّى — دون حذف تسوية مدفوعة فعلياً"],
        ],
    )
    add_paragraph(
        doc,
        "كل بند بيع يُسوّى مرة واحدة فقط (قيد فريد). الفواتير والبنود المالية لا تُحذف فيزيائياً بل تُلغى محاسبياً.",
        size=10,
        color=MUTED,
    )

    # —— 8 ——
    add_heading_custom(doc, "8. دفتر المورد والرصيد", 1)
    add_paragraph(
        doc,
        "الدفتر إضافي فقط (append-only): لا تعديل ولا حذف للقيود؛ الخطأ يُصحَّح بقيد عكسي. الرصيد = مجموع المبالغ لكل مورد داخل المتجر.",
    )
    add_table(
        doc,
        ["نوع القيد", "الإشارة", "المعنى"],
        [
            ["مستحق بيع (sale_credit)", "موجب (+)", "زاد ما للمتجر عند المورد بعد بيع"],
            ["خصم تسوية (settlement_debit)", "سالب (−)", "دُفع للمورد / خُصم من الرصيد"],
            ["سلفة / خصم / تالف / شحن / مرتجع", "سالب (−)", "تخفيضات على المستحق"],
            ["تعديل يدوي", "أي إشارة ≠ صفر", "تصحيح موثّق"],
        ],
    )
    add_paragraph(
        doc,
        "رصيد موجب يعني تقريباً أن المتجر ما زال مديناً للمورد بهذا المبلغ (حسب اصطلاح الإشارة أعلاه).",
    )

    # —— 9 ——
    add_heading_custom(doc, "9. التدقيق وأرقام الفواتير", 1)
    add_bullets(
        doc,
        [
            "عدّاد آمن لكل متجر لتوليد أرقام الفواتير دون تعارض.",
            "سجل تدقيق: من فعل ماذا، على أي كيان، مع بيانات قديمة/جديدة وعنوان IP ومعرّف الطلب.",
        ],
    )

    # —— 10 ——
    add_heading_custom(doc, "10. ماذا يفعل كل مستخدم؟", 1)

    add_heading_custom(doc, "أ) مدير المتجر", 2)
    add_numbered(
        doc,
        [
            "إعداد التصنيفات والمنتجات والعمولات والوحدات والموردين.",
            "استلام بضاعة المزارعين (دفعات مخزون).",
            "مراجعة كشف المورد والرصيد.",
            "إنشاء التسويات وتطبيق الخصومات وتسجيل الدفع.",
            "تعديل المخزون (تالف / إرجاع للمورد) ومراجعة التدقيق.",
        ],
    )

    add_heading_custom(doc, "ب) الكاشير", 2)
    add_numbered(
        doc,
        [
            "اختيار منتجات الزبون.",
            "اختيار الدفعة/المورد المتاح.",
            "إتمام البيع → فاتورة + عمولة مجمّدة + خصم كمية.",
            "تسجيل مرتجع زبون عند الحاجة.",
        ],
    )

    add_heading_custom(doc, "ج) المورد (اختياري)", 2)
    add_paragraph(doc, "إن وُجد حساب: عرض مستحقاته ومبيعاته دون صلاحيات إدارة المتجر.")

    add_heading_custom(doc, "د) مدير المنصة", 2)
    add_paragraph(doc, "إدارة الباقات والاشتراكات وحالات المتاجر — بدون ارتباط بمتجر واحد.")

    # —— 11 ——
    add_heading_custom(doc, "11. ضمانات سلامة البيانات", 1)
    add_table(
        doc,
        ["الطبقة", "ماذا تحمي؟"],
        [
            ["عزل المستأجر", "لا خلط بين متجرين"],
            ["مال الفاتورة", "مجاميع صحيحة؛ بند = عمولة + مورد"],
            ["مورد التخصيص", "لا بيع من دفعة مورد على بند مورد آخر"],
            ["المرتجع", "إعادة الكمية لنفس دفعة البيع"],
            ["التسوية", "لا دفع مزدوج لنفس البند؛ صافي محسوب"],
            ["الدفتر", "إشارة حسب النوع؛ منع تكرار نفس العملية للمورد"],
            ["الأدوار", "سوبر أدمن بلا متجر؛ الباقون بمتجر"],
            ["الحذف", "الماليات تُلغى ولا تُمسح؛ الكتالوج حذف ناعم"],
        ],
    )
    add_paragraph(
        doc,
        "ما يبقى في طبقة التطبيق: قفل الصفوف عند البيع المتزامن، تقريب المبالغ، تطابق الوحدات، سقف المرتجع، منع تسوية الملغى، انتهاء الاشتراك، وتشفير رقم الحساب.",
        size=10,
        color=MUTED,
    )

    # —— 12 ——
    add_heading_custom(doc, "12. خلاصة", 1)
    add_numbered(
        doc,
        [
            "المورد يضع بضاعته أمانة على شكل دفعات.",
            "المتجر يبيع مع اختيار حرّ للدفعة ويقتطع عمولة مجمّدة لحظة البيع.",
            "كل حركة مالية للمورد تمر عبر دفتر إضافي؛ الرصيد يُحسب منه.",
            "الدفع الفعلي عبر تسوية تفصيلية مربوطة ببنود بيع غير مكررة.",
            "المرتجعات والتالف وإلغاء الفواتير مسارات منفصلة حتى لا تختلط محاسبياً.",
        ],
    )
    add_paragraph(
        doc,
        "بهذا تصبح قاعدة البيانات عموداً فقرياً تشغيلياً ومحاسبياً؛ وطبقة الخدمات (API / نقطة البيع) تبني فوقها المعاملات اليومية والتقارير والواجهات.",
        space_before=8,
    )

    # Footer note
    add_paragraph(
        doc,
        "— نهاية التقرير —",
        size=9,
        color=MUTED,
        space_before=20,
    )
    add_paragraph(
        doc,
        "المصادر في المشروع: SYSTEM_REPORT.md · SYSTEM_OVERVIEW.md · docs/commision_system.drawio · backend/prisma/schema.prisma",
        size=8,
        color=MUTED,
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    doc.save(OUT)
    doc.save(OUT_DESKTOP)
    print("wrote", str(OUT))
    print("wrote desktop copy:", OUT_DESKTOP.exists())


if __name__ == "__main__":
    build()
