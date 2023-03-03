from dataclasses import dataclass, field

@dataclass
class Anlage():
    name: str = ''
    par: dict = field(default_factory=dict)
#endclass
