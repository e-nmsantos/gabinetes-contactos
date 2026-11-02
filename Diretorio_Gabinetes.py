import json
import os

# Base de Dados Consolidada dos Gabinetes
CONTACTOS = []
RECURSOS = []

_json_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "contactos.json")
if os.path.exists(_json_path):
    try:
        with open(_json_path, "r", encoding="utf-8") as _f:
            _raw = json.load(_f)
            CONTACTOS = [
                {
                    "gab": x.get("Gabinete", ""),
                    "area": x.get("Área / Função", x.get("Area / Funcao", "Gabinete")),
                    "cargo": x.get("Cargo", ""),
                    "nome": x.get("Nome", ""),
                    "email": x.get("E-mail", ""),
                    "direto": x.get("Telefone Direto", "") or "—",
                    "ramal": x.get("Ramal Interno", "") or "—",
                    "movel": x.get("Telemóvel", "") or "—",
                    "sala": x.get("Piso / Sala", "") or "—"
                }
                for x in _raw if x.get("Cargo")
            ]
            RECURSOS = [
                {
                    "gab": x.get("Gabinete", ""),
                    "tipo": x.get("Tipo de Recurso", ""),
                    "nome": x.get("Designação / Recurso", ""),
                    "resp": x.get("Responsável / Motorista", "") or "—",
                    "email": x.get("E-mail", "") or "—",
                    "cont": x.get("Telemóvel / Telefone", "") or "—",
                    "id": x.get("Identificador / Matrícula", "") or "—",
                    "notas": x.get("Capacidade / Detalhes", "") or "—"
                }
                for x in _raw if x.get("Tipo de Recurso")
            ]
    except Exception:
        pass

if not CONTACTOS:
    CONTACTOS = [
    # SEAO
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Chefe do Gabinete", "nome": "Dra. Sara Arrábida", "email": "sara.arrabida@mf.gov.pt", "direto": "218 816 021", "ramal": "433 021", "movel": "916 406 286", "sala": "Sala 14"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Secretariado", "nome": "Catarina Brito", "email": "catarina.brito@mf.gov.pt", "direto": "218 817 334", "ramal": "433 334", "movel": "966 389 719", "sala": "Sala 16"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Adjunta", "nome": "Fernanda Peixinho", "email": "fernanda.peixinho@mf.gov.pt", "direto": "218 817 336", "ramal": "433 336", "movel": "962 148 880", "sala": "Sala 13"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. André Morais", "email": "andre.morais@mf.gov.pt", "direto": "218 816 953", "ramal": "433 953", "movel": "—", "sala": "Sala 17"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Cláudia Madalena", "email": "claudia.madalena@mf.gov.pt", "direto": "218 817 343", "ramal": "433 343", "movel": "—", "sala": "Sala 12"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. João Fonseca", "email": "joao.fonseca@mf.gov.pt", "direto": "218 817 355", "ramal": "433 355", "movel": "—", "sala": "Sala 13"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. João Parreira", "email": "joao.parreira@mf.gov.pt", "direto": "—", "ramal": "433 340", "movel": "916 739 349", "sala": "Sala 12"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Leonor Farmhouse", "email": "leonor.farmhouse@mf.gov.pt", "direto": "218 817 340", "ramal": "433 351", "movel": "—", "sala": "Sala 9"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Lídia Martins", "email": "lidia.martins@mf.gov.pt", "direto": "—", "ramal": "433 353", "movel": "931 793 079", "sala": "Sala 11"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Lisa Ferraz da Costa", "email": "lisa.costa@mf.gov.pt", "direto": "218 817 351", "ramal": "433 339", "movel": "935 500 061", "sala": "—"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Mafalda Rodrigues", "email": "mafalda.rodrigues@mf.gov.pt", "direto": "218 817 341", "ramal": "433 341", "movel": "927 482 393", "sala": "Sala 13"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Maria João Vicente", "email": "maria.vicente@mf.gov.pt", "direto": "218 816 835", "ramal": "433 335", "movel": "937 370 061", "sala": "Sala 9"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. Paulo Almeida", "email": "paulo.almeida@mf.gov.pt", "direto": "218 817 321", "ramal": "433 321", "movel": "965 020 736", "sala": "Sala 11"},
    {"gab": "SEAO", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Soraia Ferreira", "email": "soraia.ferreira@mf.gov.pt", "direto": "218 817 320", "ramal": "433 320", "movel": "962 930 907", "sala": "Sala 11"},
    {"gab": "SEAO", "area": "Secretaria Apoio", "cargo": "Coordenadora", "nome": "Ana Maurício", "email": "ana.mauricio@mf.gov.pt", "direto": "218 817 358", "ramal": "433 358", "movel": "—", "sala": "Sala 32"},
    {"gab": "SEAO", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Paula Amorim", "email": "paula.amorim@mf.gov.pt", "direto": "218 817 254", "ramal": "433 354", "movel": "—", "sala": "—"},
    {"gab": "SEAO", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Tânia Borges", "email": "tania.borges@mf.gov.pt", "direto": "218 817 357", "ramal": "433 357", "movel": "—", "sala": "Sala 34"},
    {"gab": "SEAO", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Maria Fernandes", "email": "maria.fernandes@mf.gov.pt", "direto": "218 817 348", "ramal": "433 348", "movel": "—", "sala": "2.º Piso"},
    {"gab": "SEAO", "area": "Secretaria Apoio", "cargo": "Assistente Operacional", "nome": "Susana Moura", "email": "susana.moura@mf.gov.pt", "direto": "218 817 345", "ramal": "433 345 / 433 337", "movel": "—", "sala": "1.º Piso"},
    # SEAF
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Chefe do Gabinete", "nome": "Dr. João Pedro Santos", "email": "joao.pedro.santos@mf.gov.pt", "direto": "218 817 041", "ramal": "433 041", "movel": "963 595 038", "sala": "Sala 1"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Secretariado", "nome": "Ana Paula Pinto", "email": "anappinto@mf.gov.pt", "direto": "218 817 143", "ramal": "433 143", "movel": "962 320 617", "sala": "Sala 2"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Secretariado", "nome": "Inês Resina", "email": "ines.resina@mf.gov.pt", "direto": "218 817 144", "ramal": "433 144", "movel": "919 930 148", "sala": "Sala 2"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Marta Carmo", "email": "marta.carmo@mf.gov.pt", "direto": "218 817 133", "ramal": "433 133", "movel": "966 258 991", "sala": "Sala 8"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Cristiana Santos", "email": "cristiana.santos@mf.gov.pt", "direto": "218 817 132", "ramal": "433 132", "movel": "911 965 487", "sala": "—"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Inês Matoso", "email": "ines.matoso@mf.gov.pt", "direto": "218 817 130", "ramal": "433 130", "movel": "962 751 903", "sala": "Sala 6"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Carmen Silva", "email": "carmen.silva@mf.gov.pt", "direto": "218 817 146", "ramal": "433 146", "movel": "910 722 210", "sala": "—"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Beatriz Teixeira", "email": "beatriz.teixeira@mf.gov.pt", "direto": "218 817 148", "ramal": "433 148", "movel": "933 173 494", "sala": "Sala 8"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Catarina Alvarez", "email": "catarina.alvarez@mf.gov.pt", "direto": "218 817 147", "ramal": "433 147", "movel": "919 148 277", "sala": "Sala 6"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Mariana Branco", "email": "marianagameirobranco@mf.gov.pt", "direto": "218 816 824", "ramal": "433 824", "movel": "914 613 893", "sala": "Sala 9"},
    {"gab": "SEAF", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Liliana Escada", "email": "liliana.escada@mf.gov.pt", "direto": "—", "ramal": "433 135", "movel": "968 939 126", "sala": "—"},
    {"gab": "SEAF", "area": "Secretaria Apoio", "cargo": "Coordenadora", "nome": "Alexandra Estorninho", "email": "alexandrae@mf.gov.pt", "direto": "218 817 117", "ramal": "433 117", "movel": "—", "sala": "—"},
    {"gab": "SEAF", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Maria José Nogueira", "email": "maria.nogueira@mf.gov.pt", "direto": "218 817 125", "ramal": "433 125", "movel": "—", "sala": "Sala 12"},
    {"gab": "SEAF", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Ana Ramos", "email": "anamaria.ramos@mf.gov.pt", "direto": "218 817 108", "ramal": "433 108", "movel": "—", "sala": "—"},
    {"gab": "SEAF", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Helena Maria Brázio", "email": "helena.brazio@mf.gov.pt", "direto": "218 817 131", "ramal": "433 131", "movel": "—", "sala": "—"},
    {"gab": "SEAF", "area": "Secretaria Apoio", "cargo": "Assistente Operacional", "nome": "Elisabete Pica", "email": "elisabete.pica@mf.gov.pt", "direto": "218 817 090", "ramal": "433 090", "movel": "—", "sala": "Sala 11"},
    # SEAP
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Chefe do Gabinete", "nome": "Dra. Alexandra Alvarez", "email": "alexandra.alvarez@mf.gov.pt", "direto": "218 817 031", "ramal": "433 031", "movel": "964 786 496", "sala": "Sala 6"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Secretariado", "nome": "Raquel Coluna", "email": "raquel.coluna@mf.gov.pt", "direto": "218 817 257", "ramal": "433 257", "movel": "934 370 770", "sala": "Sala 8"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Secretariado", "nome": "Anabela Franco", "email": "anabela.franco@mf.gov.pt", "direto": "218 817 245", "ramal": "433 245", "movel": "963 368 427", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Paula Baptista", "email": "paula.baptista@mf.gov.pt", "direto": "218 817 979", "ramal": "433 979", "movel": "931 370 866", "sala": "Sala 4"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Adjunto", "nome": "Dr. João Miguel Costa", "email": "joao.m.costa@mf.gov.pt", "direto": "218 817 251", "ramal": "433 251", "movel": "963 280 234", "sala": "Sala 3"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Fátima Russo", "email": "fatima.russo@mf.gov.pt", "direto": "218 817 290", "ramal": "433 290", "movel": "930 620 027", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Adjunta", "nome": "Dra. Marta Nunes", "email": "marta.nunes@mf.gov.pt", "direto": "218 817 246", "ramal": "433 246", "movel": "936 200 007", "sala": "Sala 2"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Fátima Rodrigues", "email": "fatima.rodriques@mf.gov.pt", "direto": "218 817 889", "ramal": "433 889", "movel": "935 240 050", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Sónia Matos", "email": "sonia.matos@mf.gov.pt", "direto": "218 817 250", "ramal": "433 250", "movel": "938 560 193", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. Daniel Salazar", "email": "daniel.salazar@mf.gov.pt", "direto": "218 817 997", "ramal": "433 997", "movel": "913 261 668", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Carina Anunciação", "email": "carina.anunciacao@mf.gov.pt", "direto": "218 817 229", "ramal": "433 229", "movel": "962 448 044", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Raquel Figueiredo", "email": "raquel.figueiredo@mf.gov.pt", "direto": "218 817 333", "ramal": "433 333", "movel": "912 735 591", "sala": "Sala 7"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Liliana Fontoura", "email": "liliana.fontoura@mf.gov.pt", "direto": "—", "ramal": "433 253", "movel": "969 001 992", "sala": "—"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnica Especialista", "nome": "Dra. Sofia Vala Rocha", "email": "sofiavalarocha@mf.gov.pt", "direto": "218 817 274", "ramal": "433 274", "movel": "935 410 060", "sala": "Sala 4"},
    {"gab": "SEAP", "area": "Gabinete", "cargo": "Técnico Especialista", "nome": "Dr. Francisco Mota Ferreira", "email": "francisco.ferreira@mf.gov.pt", "direto": "—", "ramal": "433 256", "movel": "913 114 960", "sala": "Sala 3"},
    {"gab": "SEAP", "area": "Secretaria Apoio", "cargo": "Coordenadora", "nome": "Ana Cristina Carvalho", "email": "anacristina.carvalho@mf.gov.pt", "direto": "218 817 145", "ramal": "433 145", "movel": "969 465 268", "sala": "—"},
    {"gab": "SEAP", "area": "Secretaria Apoio", "cargo": "Colaboradora", "nome": "Vera Mendes", "email": "vera.mendes@mf.gov.pt", "direto": "218 817 207", "ramal": "433 207", "movel": "924 349 012", "sala": "Sala 5"},
    {"gab": "SEAP", "area": "Secretaria Apoio", "cargo": "Assistente Operacional", "nome": "Joana Mira", "email": "joana.mira@mf.gov.pt", "direto": "—", "ramal": "433 206", "movel": "918 294 771", "sala": "—"}
]

RECURSOS = [
    {"gab": "SEAO", "tipo": "Viatura", "nome": "Mercedes", "resp": "João Esteves", "email": "manuel.esteves@mf.gov.pt", "cont": "964 777 330 / 434 11 008", "id": "BU-77-QX", "notas": "Viatura Afeta"},
    {"gab": "SEAO", "tipo": "Viatura", "nome": "SMART #1 Pro", "resp": "Pedro Lima", "email": "pedro.lima@mf.gov.pt", "cont": "932 980 264 / 218 846 854", "id": "CH-68-DA", "notas": "Viatura Afeta"},
    {"gab": "SEAO", "tipo": "Viatura", "nome": "Renault Megane", "resp": "Reserva Gabinete", "email": "—", "cont": "—", "id": "AU-27-PR", "notas": "Reserva / Frota"},
    {"gab": "SEAO", "tipo": "Viatura", "nome": "BMW X3", "resp": "Reserva Gabinete", "email": "—", "cont": "—", "id": "89-XG-38", "notas": "Reserva / Frota"},
    {"gab": "SEAO", "tipo": "Espaço", "nome": "Sala de Reuniões", "resp": "—", "email": "—", "cont": "—", "id": "Sala 19 (1.º Piso)", "notas": "Capacidade para 10 pessoas"},
    {"gab": "SEAF", "tipo": "Viatura", "nome": "BMW", "resp": "Helder Sousa", "email": "helder.sousa@mf.gov.pt", "cont": "938 630 113 / 434 11 008", "id": "AA-40-PG", "notas": "Viatura Afeta"},
    {"gab": "SEAF", "tipo": "Viatura", "nome": "Mercedes", "resp": "Válter Pires", "email": "valterpires@msn.com", "cont": "960 236 434 / 218 846 854", "id": "81-OH-94", "notas": "Viatura Afeta"},
    {"gab": "SEAF", "tipo": "Viatura", "nome": "BMW", "resp": "Válter Pires", "email": "valterpires@msn.com", "cont": "960 236 434 / 218 846 854", "id": "16-21-ZO", "notas": "Viatura Afeta"},
    {"gab": "SEAF", "tipo": "Espaço", "nome": "Sala de Reuniões", "resp": "—", "email": "—", "cont": "—", "id": "Sala 10 (2.º Piso)", "notas": "Capacidade 10 pessoas | Ext. 434 10 302"},
    {"gab": "SEAP", "tipo": "Viatura", "nome": "Mercedes", "resp": "Paulo Martins", "email": "paulo.martins@mf.gov.pt", "cont": "913 956 381 / 218 846 854", "id": "BU-50-QZ", "notas": "Viatura Afeta"},
    {"gab": "SEAP", "tipo": "Viatura", "nome": "Smart", "resp": "Filipe Marques", "email": "filipe.marques@mf.gov.pt", "cont": "939 470 481 / 218 846 854", "id": "BU-81-IV", "notas": "Viatura Afeta"},
    {"gab": "SEAP", "tipo": "Espaço", "nome": "Sala de Reuniões", "resp": "—", "email": "—", "cont": "—", "id": "Sala A/B (1.º Piso)", "notas": "Capacidade para 10 Pessoas"}
]

class AppGabinetes(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Diretório de Contactos — Gabinetes MF")
        self.geometry("1100x650")
        self.minsize(850, 500)
        self.configure(bg="#F1F5F9")
        
        self.current_gab = "TODOS"
        self._build_ui()
        self.apply_filter()

    def _build_ui(self):
        # Header Frame
        header = tk.Frame(self, bg="#0F2C59", height=65)
        header.pack(fill="x", side="top")
        
        tk.Label(header, text="Ministério das Finanças", font=("Segoe UI", 9, "bold"), fg="#94A3B8", bg="#0F2C59").pack(anchor="w", padx=20, pady=(10,0))
        tk.Label(header, text="Diretório Institucional dos Gabinetes (MEF • SEAO • SEAF • SETF • SEAP • GPEARI)", font=("Segoe UI", 13, "bold"), fg="white", bg="#0F2C59").pack(anchor="w", padx=20, pady=(0,10))

        # Control Bar
        ctrl_frame = tk.Frame(self, bg="#FFFFFF", bd=1, relief="solid")
        ctrl_frame.pack(fill="x", padx=16, pady=12)

        # Search
        tk.Label(ctrl_frame, text="🔍 Pesquisar:", font=("Segoe UI", 10, "bold"), bg="#FFFFFF", fg="#334155").pack(side="left", padx=(15, 6), pady=10)
        self.search_var = tk.StringVar()
        self.search_var.trace_add("write", lambda *args: self.apply_filter())
        entry = tk.Entry(ctrl_frame, textvariable=self.search_var, font=("Segoe UI", 10), width=28, relief="groove", bd=1)
        entry.pack(side="left", padx=5, pady=10)

        # Gabinetes filter buttons
        tk.Label(ctrl_frame, text="Filtrar:", font=("Segoe UI", 9, "bold"), bg="#FFFFFF", fg="#64748B").pack(side="left", padx=(15, 5))
        self.gab_buttons = {}
        for g in ["TODOS", "MEF", "SEAO", "SEAF", "SETF", "SEAP", "GPEARI"]:
            btn = tk.Button(ctrl_frame, text=g, font=("Segoe UI", 9, "bold"), relief="flat", padx=10, pady=4, cursor="hand2",
                            command=lambda code=g: self.set_filter_gab(code))
            btn.pack(side="left", padx=2, pady=8)
            self.gab_buttons[g] = btn
        self._update_gab_buttons()

        # Action: Open Mail
        btn_mail = tk.Button(ctrl_frame, text="✉ Enviar Email", font=("Segoe UI", 9, "bold"), bg="#2563EB", fg="white", relief="flat", padx=12, pady=4, cursor="hand2", command=self.action_send_email)
        btn_mail.pack(side="right", padx=15, pady=8)

        # Tabs (Notebook)
        self.nb = ttk.Notebook(self)
        self.nb.pack(fill="both", expand=True, padx=16, pady=(0, 14))

        # Tab 1: Pessoal
        self.tab_pessoal = tk.Frame(self.nb, bg="#FFFFFF")
        self.nb.add(self.tab_pessoal, text="  Colaboradores e Apoio  ")

        cols = ("gab", "area", "cargo", "nome", "ramal", "direto", "movel", "sala", "email")
        self.tree_pessoal = ttk.Treeview(self.tab_pessoal, columns=cols, show="headings", selectmode="browse")
        
        headers = [
            ("gab", "Gabinete", 80, "center"),
            ("area", "Área", 120, "center"),
            ("cargo", "Cargo", 150, "w"),
            ("nome", "Nome Completo", 180, "w"),
            ("ramal", "Ramal Interno", 110, "center"),
            ("direto", "Telefone Direto", 110, "center"),
            ("movel", "Telemóvel", 110, "center"),
            ("sala", "Sala / Piso", 90, "center"),
            ("email", "Correio Eletrónico", 200, "w")
        ]
        for col_id, col_text, col_w, align in headers:
            self.tree_pessoal.heading(col_id, text=col_text)
            self.tree_pessoal.column(col_id, width=col_w, anchor=align)

        scroll_y1 = ttk.Scrollbar(self.tab_pessoal, orient="vertical", command=self.tree_pessoal.yview)
        self.tree_pessoal.configure(yscrollcommand=scroll_y1.set)
        scroll_y1.pack(side="right", fill="y")
        self.tree_pessoal.pack(side="left", fill="both", expand=True)

        # Tab 2: Frota & Espaços
        self.tab_recursos = tk.Frame(self.nb, bg="#FFFFFF")
        self.nb.add(self.tab_recursos, text="  Frota Automóvel e Salas  ")

        cols_r = ("gab", "tipo", "nome", "resp", "cont", "id", "notas")
        self.tree_recursos = ttk.Treeview(self.tab_recursos, columns=cols_r, show="headings", selectmode="browse")
        
        headers_r = [
            ("gab", "Gabinete", 80, "center"),
            ("tipo", "Tipo", 100, "center"),
            ("nome", "Designação / Viatura", 150, "w"),
            ("resp", "Motorista / Responsável", 170, "w"),
            ("cont", "Contactos Telefónicos", 180, "center"),
            ("id", "Matrícula / Sala", 130, "center"),
            ("notas", "Observações / Lotação", 200, "w")
        ]
        for col_id, col_text, col_w, align in headers_r:
            self.tree_recursos.heading(col_id, text=col_text)
            self.tree_recursos.column(col_id, width=col_w, anchor=align)

        scroll_y2 = ttk.Scrollbar(self.tab_recursos, orient="vertical", command=self.tree_recursos.yview)
        self.tree_recursos.configure(yscrollcommand=scroll_y2.set)
        scroll_y2.pack(side="right", fill="y")
        self.tree_recursos.pack(side="left", fill="both", expand=True)

    def set_filter_gab(self, code):
        self.current_gab = code
        self._update_gab_buttons()
        self.apply_filter()

    def _update_gab_buttons(self):
        for code, btn in self.gab_buttons.items():
            if code == self.current_gab:
                btn.configure(bg="#0F2C59", fg="white")
            else:
                btn.configure(bg="#E2E8F0", fg="#334155")

    def apply_filter(self):
        q = self.search_var.get().lower().strip()
        
        # Filtrar Pessoal
        self.tree_pessoal.delete(*self.tree_pessoal.get_children())
        for c in CONTACTOS:
            if self.current_gab != "TODOS" and c["gab"] != self.current_gab:
                continue
            text_search = f"{c['nome']} {c['cargo']} {c['email']} {c['ramal']} {c['movel']} {c['direto']} {c['sala']}".lower()
            if q and q not in text_search:
                continue
            self.tree_pessoal.insert("", "end", values=(
                c["gab"], c["area"], c["cargo"], c["nome"], c["ramal"], c["direto"], c["movel"], c["sala"], c["email"]
            ))

        # Filtrar Recursos
        self.tree_recursos.delete(*self.tree_recursos.get_children())
        for r in RECURSOS:
            if self.current_gab != "TODOS" and r["gab"] != self.current_gab:
                continue
            text_search = f"{r['nome']} {r['resp']} {r['cont']} {r['id']} {r['notas']}".lower()
            if q and q not in text_search:
                continue
            self.tree_recursos.insert("", "end", values=(
                r["gab"], r["tipo"], r["nome"], r["resp"], r["cont"], r["id"], r["notas"]
            ))

    def action_send_email(self):
        selected = self.tree_pessoal.selection()
        if not selected:
            messagebox.showinfo("Aviso", "Selecione primeiro um contacto na lista.")
            return
        item = self.tree_pessoal.item(selected[0])
        email = item["values"][8]
        if email and email != "—":
            webbrowser.open(f"mailto:{email}")

if __name__ == "__main__":
    app = AppGabinetes()
    app.mainloop()