from typing import List, Optional
from pydantic import HttpUrl


class Media:
    """Contains list with media"""

    media: Optional[List[HttpUrl]] = None
