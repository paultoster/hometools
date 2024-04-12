function m_gew = nefz_gewichtsklassen(m_in)


if( m_in > 1080 && m_in <= 1190 )

        m_gew = 1130;

elseif( m_in > 1190 && m_in <= 1305 )

        m_gew = 1250;

elseif( m_in > 1305 && m_in <= 1420 )

        m_gew = 1360;

elseif( m_in > 1420 && m_in <= 1530 )

        m_gew = 1470;

elseif( m_in > 1530 && m_in <= 1640 )

        m_gew = 1590;

elseif( m_in > 1640 && m_in <= 1760 )

        m_gew = 1700;

elseif( m_in > 1760 && m_in <= 1870 )

        m_gew = 1810;

elseif( m_in > 1870 && m_in <= 1980 )

        m_gew = 1930;

elseif( m_in > 1980 && m_in <= 2100 )

        m_gew = 2040;

elseif( m_in > 2100 && m_in <= 2210 )

        m_gew = 2150;

elseif( m_in > 2210 )

        m_gew = 2270;
end   
