package ott.j4jg_be.application.port.out;

import ott.j4jg_be.domain.Scrap;

public interface updateScrapPort {

    void cancelScrap(int scrapId);
    void updateScrap(Scrap scrap, boolean status);
}
