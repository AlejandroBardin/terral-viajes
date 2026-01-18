class HomeController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
    @hero_title = Setting.find_by(key: "hero_title")&.value || "Vacaciones soñadas"
    @hero_subtitle = Setting.find_by(key: "hero_subtitle")&.value || "Descubrí los mejores destinos con nosotros"
    @hero_image = "https://lh3.googleusercontent.com/aida-public/AB6AXuBj76qEFPUBzbwuay9fscDB9LsAtWCHYcXynHgdNYEvrax97FTU603QCQWPTQzH_zj3Bg1zcdYgLYe-ntU2i44J5FAHLbZ3nL1cOtU_D6VYnMIRgjWkrq07p7e42ZJ4bVaZMnXzt5cQuKxjYbmy9fsfRdcIiouhLA6bEFN4UER4-pTxEIDMLzolT4e7W3oCzCprbH6kV5pAVnKAI-d9H961pFlZeTnCtXk2afGhtJZGp4IwBzGMfeEerZZOJpTi7xrn57ofPGc04ao"
    @packages = Package.featured.by_price
  end
end
