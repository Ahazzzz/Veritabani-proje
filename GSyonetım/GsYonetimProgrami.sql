PGDMP  ;    #                |         	   GSyonetim    17.2    17.1 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16883 	   GSyonetim    DATABASE     �   CREATE DATABASE "GSyonetim" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "GSyonetim";
                     postgres    false                       1255    25747    check_id_positive()    FUNCTION     �  CREATE FUNCTION public.check_id_positive() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Tüm id alanlarının 0'dan küçük olup olmadığını kontrol et
    IF NEW.antrenmanid < 0 OR
       NEW.bransid < 0 OR
       NEW.tesisid < 0 OR
       NEW.antrenorid < 0 OR
       NEW.basketbolcuid < 0 OR
       NEW.oyuncuid < 0 OR
       NEW.doktorid < 0 OR
       NEW.esporcuid < 0 OR
       NEW.futbolcuid < 0 OR
       NEW.voleybolcuid < 0 OR
       NEW.ligid < 0 OR
       NEW.personelid < 0 OR
       NEW.sponsorid < 0 OR
       NEW.takimid < 0 THEN
        RAISE EXCEPTION 'ID alanları 0''dan küçük olamaz!';
    END IF;

    RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.check_id_positive();
       public               postgres    false                        1255    25745    update_malideger()    FUNCTION     L  CREATE FUNCTION public.update_malideger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Maliyeti güncelle
    UPDATE malideger
    SET malideger = (
        SELECT COALESCE(SUM(paradegeri), 0)
        FROM oyuncular
        WHERE bransid = NEW.bransid
    )
    WHERE bransid = NEW.bransid;

    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.update_malideger();
       public               postgres    false            �            1255    25713    update_malideger_trigger()    FUNCTION     w  CREATE FUNCTION public.update_malideger_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE malideger
    SET malideger = toplam_paradeger
    FROM (
        SELECT bransid, SUM(paradegeri) AS toplam_paradeger
        FROM oyuncular
        GROUP BY bransid
    ) AS toplamlar
    WHERE malideger.bransid = toplamlar.bransid;

    RETURN NULL;
END;
$$;
 1   DROP FUNCTION public.update_malideger_trigger();
       public               postgres    false            �            1255    25714    update_team_para_degeri()    FUNCTION     T  CREATE FUNCTION public.update_team_para_degeri() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE takim
    SET totalparadegeri = (SELECT COALESCE(SUM(paradegeri), 0) 
                           FROM oyuncular 
                           WHERE takimid = NEW.takimid)
    WHERE takimid = NEW.takimid;
    RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.update_team_para_degeri();
       public               postgres    false            �            1255    25715    update_total_malideger()    FUNCTION       CREATE FUNCTION public.update_total_malideger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Brans
    SET MaliDeger = (SELECT SUM(MaliDeger) FROM MaliDeger WHERE BransID = NEW.BransID)
    WHERE BransID = NEW.BransID;
    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.update_total_malideger();
       public               postgres    false            �            1255    25743    update_totalparadegeri()    FUNCTION     :  CREATE FUNCTION public.update_totalparadegeri() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE takim
    SET totalparadegeri = (
        SELECT COALESCE(SUM(paradegeri), 0)
        FROM oyuncular
        WHERE takimid = NEW.takimid
    )
    WHERE takimid = NEW.takimid;

    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.update_totalparadegeri();
       public               postgres    false            �            1255    25735    validate_antrenman_tarih()    FUNCTION       CREATE FUNCTION public.validate_antrenman_tarih() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.tarih < CURRENT_DATE THEN
        RAISE EXCEPTION 'Antrenman tarihi geçmiş bir tarih olamaz: %', NEW.tarih;
    END IF;
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.validate_antrenman_tarih();
       public               postgres    false            �            1255    25727    validate_bransid()    FUNCTION     �   CREATE FUNCTION public.validate_bransid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.bransid < 0 THEN
        RAISE EXCEPTION 'bransid cannot be less than 0';
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.validate_bransid();
       public               postgres    false            �            1255    25737    validate_paradegeri()    FUNCTION     �   CREATE FUNCTION public.validate_paradegeri() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.paradegeri < 0 THEN
        RAISE EXCEPTION 'Oyuncu para değeri negatif olamaz: %', NEW.paradegeri;
    END IF;
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.validate_paradegeri();
       public               postgres    false                       1255    25749    validate_sezon_format()    FUNCTION     T  CREATE FUNCTION public.validate_sezon_format() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Sezon değeri "YYYY-YYYY" formatında olmalı
    IF NEW.sezon !~ '^\d{4}-\d{4}$' THEN
        RAISE EXCEPTION 'Sezon değeri "YYYY-YYYY" formatında olmalıdır. Örneğin: 2023-2024';
    END IF;

    -- Başlangıç yılı bitiş yılından büyük olmamalı
    IF substring(NEW.sezon from 1 for 4)::integer > substring(NEW.sezon from 6 for 4)::integer THEN
        RAISE EXCEPTION 'Sezon başlangıç yılı bitiş yılından büyük olamaz.';
    END IF;

    RETURN NEW;
END;
$_$;
 .   DROP FUNCTION public.validate_sezon_format();
       public               postgres    false            �            1255    25719    validate_takimid()    FUNCTION     �   CREATE FUNCTION public.validate_takimid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.takimid < 0 THEN
        RAISE EXCEPTION 'takimid cannot be less than 0';
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.validate_takimid();
       public               postgres    false            �            1255    25739    validate_unique_brans_adi()    FUNCTION     %  CREATE FUNCTION public.validate_unique_brans_adi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM brans WHERE adi = NEW.adi AND bransid != NEW.bransid) THEN
        RAISE EXCEPTION 'Branş adı zaten mevcut: %', NEW.adi;
    END IF;
    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.validate_unique_brans_adi();
       public               postgres    false            �            1255    25741    validate_unique_tesis()    FUNCTION     S  CREATE FUNCTION public.validate_unique_tesis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM tesis WHERE adi = NEW.adi AND sehir = NEW.sehir AND tesisid != NEW.tesisid) THEN
        RAISE EXCEPTION 'Aynı şehirde aynı adla başka bir tesis zaten var: %', NEW.adi;
    END IF;
    RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.validate_unique_tesis();
       public               postgres    false            �            1259    17209 	   antrenman    TABLE     �   CREATE TABLE public.antrenman (
    antrenmanid integer NOT NULL,
    bransid integer,
    tesisid integer,
    tarih date NOT NULL
);
    DROP TABLE public.antrenman;
       public         heap r       postgres    false            �            1259    17208    antrenman_antrenmanid_seq    SEQUENCE     �   CREATE SEQUENCE public.antrenman_antrenmanid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.antrenman_antrenmanid_seq;
       public               postgres    false    236            �           0    0    antrenman_antrenmanid_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.antrenman_antrenmanid_seq OWNED BY public.antrenman.antrenmanid;
          public               postgres    false    235            �            1259    16927    antrenor    TABLE     �   CREATE TABLE public.antrenor (
    antrenorid integer NOT NULL,
    adi character varying(255) NOT NULL,
    takimid integer,
    bransid integer
);
    DROP TABLE public.antrenor;
       public         heap r       postgres    false            �            1259    16926    antrenor_antrenorid_seq    SEQUENCE     �   CREATE SEQUENCE public.antrenor_antrenorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.antrenor_antrenorid_seq;
       public               postgres    false    224            �           0    0    antrenor_antrenorid_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.antrenor_antrenorid_seq OWNED BY public.antrenor.antrenorid;
          public               postgres    false    223            �            1259    25673    basketbolcu    TABLE     �   CREATE TABLE public.basketbolcu (
    basketbolcuid integer NOT NULL,
    oyuncuid integer NOT NULL,
    pozisyon character varying(50),
    takimid integer
);
    DROP TABLE public.basketbolcu;
       public         heap r       postgres    false            �            1259    25672    basketbolcu_basketbolcuid_seq    SEQUENCE     �   CREATE SEQUENCE public.basketbolcu_basketbolcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.basketbolcu_basketbolcuid_seq;
       public               postgres    false    243            �           0    0    basketbolcu_basketbolcuid_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.basketbolcu_basketbolcuid_seq OWNED BY public.basketbolcu.basketbolcuid;
          public               postgres    false    242            �            1259    16901    brans    TABLE     �   CREATE TABLE public.brans (
    bransid integer NOT NULL,
    adi character varying(255) NOT NULL,
    takimid integer,
    brans_adi character varying(255)
);
    DROP TABLE public.brans;
       public         heap r       postgres    false            �            1259    16900    brans_bransid_seq    SEQUENCE     �   CREATE SEQUENCE public.brans_bransid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.brans_bransid_seq;
       public               postgres    false    220            �           0    0    brans_bransid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.brans_bransid_seq OWNED BY public.brans.bransid;
          public               postgres    false    219            �            1259    16939    doktor    TABLE     |   CREATE TABLE public.doktor (
    doktorid integer NOT NULL,
    adi character varying(255) NOT NULL,
    bransid integer
);
    DROP TABLE public.doktor;
       public         heap r       postgres    false            �            1259    16938    doktor_doktorid_seq    SEQUENCE     �   CREATE SEQUENCE public.doktor_doktorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.doktor_doktorid_seq;
       public               postgres    false    226            �           0    0    doktor_doktorid_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.doktor_doktorid_seq OWNED BY public.doktor.doktorid;
          public               postgres    false    225            �            1259    25690    esporcu    TABLE     �   CREATE TABLE public.esporcu (
    esporcuid integer NOT NULL,
    oyuncuid integer NOT NULL,
    oyunadi character varying(50),
    takimid integer
);
    DROP TABLE public.esporcu;
       public         heap r       postgres    false            �            1259    25689    esporcu_esporcuid_seq    SEQUENCE     �   CREATE SEQUENCE public.esporcu_esporcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.esporcu_esporcuid_seq;
       public               postgres    false    245            �           0    0    esporcu_esporcuid_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.esporcu_esporcuid_seq OWNED BY public.esporcu.esporcuid;
          public               postgres    false    244            �            1259    25639    futbolcu    TABLE     �   CREATE TABLE public.futbolcu (
    futbolcuid integer NOT NULL,
    oyuncuid integer NOT NULL,
    pozisyon character varying(50),
    takimid integer
);
    DROP TABLE public.futbolcu;
       public         heap r       postgres    false            �            1259    25638    futbolcu_futbolcuid_seq    SEQUENCE     �   CREATE SEQUENCE public.futbolcu_futbolcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.futbolcu_futbolcuid_seq;
       public               postgres    false    239            �           0    0    futbolcu_futbolcuid_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.futbolcu_futbolcuid_seq OWNED BY public.futbolcu.futbolcuid;
          public               postgres    false    238            �            1259    16980    lig    TABLE     �   CREATE TABLE public.lig (
    ligid integer NOT NULL,
    adi character varying(255) NOT NULL,
    bransid integer,
    sezon character varying(255) NOT NULL
);
    DROP TABLE public.lig;
       public         heap r       postgres    false            �            1259    16979    lig_ligid_seq    SEQUENCE     �   CREATE SEQUENCE public.lig_ligid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.lig_ligid_seq;
       public               postgres    false    232            �           0    0    lig_ligid_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.lig_ligid_seq OWNED BY public.lig.ligid;
          public               postgres    false    231            �            1259    17414 	   malideger    TABLE     �   CREATE TABLE public.malideger (
    bransid integer NOT NULL,
    brans_adi character varying(255) NOT NULL,
    malideger numeric(15,2)
);
    DROP TABLE public.malideger;
       public         heap r       postgres    false            �            1259    16951 	   oyuncular    TABLE     �   CREATE TABLE public.oyuncular (
    oyuncuid integer NOT NULL,
    adi character varying(255) NOT NULL,
    takimid integer,
    paradegeri numeric(10,2) NOT NULL,
    bransid integer
);
    DROP TABLE public.oyuncular;
       public         heap r       postgres    false            �            1259    16950    oyuncu_oyuncuid_seq    SEQUENCE     �   CREATE SEQUENCE public.oyuncu_oyuncuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.oyuncu_oyuncuid_seq;
       public               postgres    false    228            �           0    0    oyuncu_oyuncuid_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.oyuncu_oyuncuid_seq OWNED BY public.oyuncular.oyuncuid;
          public               postgres    false    227            �            1259    17195    personel    TABLE     �   CREATE TABLE public.personel (
    personelid integer NOT NULL,
    adi character varying(255) NOT NULL,
    gorev character varying(255) NOT NULL,
    tesisid integer
);
    DROP TABLE public.personel;
       public         heap r       postgres    false            �            1259    17194    personel_personelid_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_personelid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.personel_personelid_seq;
       public               postgres    false    234            �           0    0    personel_personelid_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.personel_personelid_seq OWNED BY public.personel.personelid;
          public               postgres    false    233            �            1259    16968    sponsor    TABLE     ~   CREATE TABLE public.sponsor (
    sponsorid integer NOT NULL,
    adi character varying(255) NOT NULL,
    takimid integer
);
    DROP TABLE public.sponsor;
       public         heap r       postgres    false            �            1259    16967    sponsor_sponsorid_seq    SEQUENCE     �   CREATE SEQUENCE public.sponsor_sponsorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.sponsor_sponsorid_seq;
       public               postgres    false    230            �           0    0    sponsor_sponsorid_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.sponsor_sponsorid_seq OWNED BY public.sponsor.sponsorid;
          public               postgres    false    229            �            1259    16894    takim    TABLE     �   CREATE TABLE public.takim (
    takimid integer NOT NULL,
    adi character varying(255) NOT NULL,
    totalparadegeri numeric DEFAULT 0
);
    DROP TABLE public.takim;
       public         heap r       postgres    false            �            1259    16893    takim_takimid_seq    SEQUENCE     �   CREATE SEQUENCE public.takim_takimid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.takim_takimid_seq;
       public               postgres    false    218            �           0    0    takim_takimid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.takim_takimid_seq OWNED BY public.takim.takimid;
          public               postgres    false    217            �            1259    16913    tesis    TABLE     �   CREATE TABLE public.tesis (
    tesisid integer NOT NULL,
    adi character varying(255) NOT NULL,
    sehir character varying(255) NOT NULL,
    takimid integer
);
    DROP TABLE public.tesis;
       public         heap r       postgres    false            �            1259    16912    tesis_tesisid_seq    SEQUENCE     �   CREATE SEQUENCE public.tesis_tesisid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tesis_tesisid_seq;
       public               postgres    false    222            �           0    0    tesis_tesisid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.tesis_tesisid_seq OWNED BY public.tesis.tesisid;
          public               postgres    false    221            �            1259    25656 
   voleybolcu    TABLE     �   CREATE TABLE public.voleybolcu (
    voleybolcuid integer NOT NULL,
    oyuncuid integer NOT NULL,
    mevki character varying(50),
    takimid integer
);
    DROP TABLE public.voleybolcu;
       public         heap r       postgres    false            �            1259    25655    voleybolcu_voleybolcuid_seq    SEQUENCE     �   CREATE SEQUENCE public.voleybolcu_voleybolcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.voleybolcu_voleybolcuid_seq;
       public               postgres    false    241            �           0    0    voleybolcu_voleybolcuid_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.voleybolcu_voleybolcuid_seq OWNED BY public.voleybolcu.voleybolcuid;
          public               postgres    false    240            �           2604    17372    antrenman antrenmanid    DEFAULT     ~   ALTER TABLE ONLY public.antrenman ALTER COLUMN antrenmanid SET DEFAULT nextval('public.antrenman_antrenmanid_seq'::regclass);
 D   ALTER TABLE public.antrenman ALTER COLUMN antrenmanid DROP DEFAULT;
       public               postgres    false    235    236    236            �           2604    17373    antrenor antrenorid    DEFAULT     z   ALTER TABLE ONLY public.antrenor ALTER COLUMN antrenorid SET DEFAULT nextval('public.antrenor_antrenorid_seq'::regclass);
 B   ALTER TABLE public.antrenor ALTER COLUMN antrenorid DROP DEFAULT;
       public               postgres    false    224    223    224            �           2604    25676    basketbolcu basketbolcuid    DEFAULT     �   ALTER TABLE ONLY public.basketbolcu ALTER COLUMN basketbolcuid SET DEFAULT nextval('public.basketbolcu_basketbolcuid_seq'::regclass);
 H   ALTER TABLE public.basketbolcu ALTER COLUMN basketbolcuid DROP DEFAULT;
       public               postgres    false    243    242    243            �           2604    17375    brans bransid    DEFAULT     n   ALTER TABLE ONLY public.brans ALTER COLUMN bransid SET DEFAULT nextval('public.brans_bransid_seq'::regclass);
 <   ALTER TABLE public.brans ALTER COLUMN bransid DROP DEFAULT;
       public               postgres    false    220    219    220            �           2604    17376    doktor doktorid    DEFAULT     r   ALTER TABLE ONLY public.doktor ALTER COLUMN doktorid SET DEFAULT nextval('public.doktor_doktorid_seq'::regclass);
 >   ALTER TABLE public.doktor ALTER COLUMN doktorid DROP DEFAULT;
       public               postgres    false    226    225    226            �           2604    25693    esporcu esporcuid    DEFAULT     v   ALTER TABLE ONLY public.esporcu ALTER COLUMN esporcuid SET DEFAULT nextval('public.esporcu_esporcuid_seq'::regclass);
 @   ALTER TABLE public.esporcu ALTER COLUMN esporcuid DROP DEFAULT;
       public               postgres    false    245    244    245            �           2604    25642    futbolcu futbolcuid    DEFAULT     z   ALTER TABLE ONLY public.futbolcu ALTER COLUMN futbolcuid SET DEFAULT nextval('public.futbolcu_futbolcuid_seq'::regclass);
 B   ALTER TABLE public.futbolcu ALTER COLUMN futbolcuid DROP DEFAULT;
       public               postgres    false    239    238    239            �           2604    17379 	   lig ligid    DEFAULT     f   ALTER TABLE ONLY public.lig ALTER COLUMN ligid SET DEFAULT nextval('public.lig_ligid_seq'::regclass);
 8   ALTER TABLE public.lig ALTER COLUMN ligid DROP DEFAULT;
       public               postgres    false    231    232    232            �           2604    17381    oyuncular oyuncuid    DEFAULT     u   ALTER TABLE ONLY public.oyuncular ALTER COLUMN oyuncuid SET DEFAULT nextval('public.oyuncu_oyuncuid_seq'::regclass);
 A   ALTER TABLE public.oyuncular ALTER COLUMN oyuncuid DROP DEFAULT;
       public               postgres    false    228    227    228            �           2604    17382    personel personelid    DEFAULT     z   ALTER TABLE ONLY public.personel ALTER COLUMN personelid SET DEFAULT nextval('public.personel_personelid_seq'::regclass);
 B   ALTER TABLE public.personel ALTER COLUMN personelid DROP DEFAULT;
       public               postgres    false    234    233    234            �           2604    17383    sponsor sponsorid    DEFAULT     v   ALTER TABLE ONLY public.sponsor ALTER COLUMN sponsorid SET DEFAULT nextval('public.sponsor_sponsorid_seq'::regclass);
 @   ALTER TABLE public.sponsor ALTER COLUMN sponsorid DROP DEFAULT;
       public               postgres    false    229    230    230            �           2604    17384    takim takimid    DEFAULT     n   ALTER TABLE ONLY public.takim ALTER COLUMN takimid SET DEFAULT nextval('public.takim_takimid_seq'::regclass);
 <   ALTER TABLE public.takim ALTER COLUMN takimid DROP DEFAULT;
       public               postgres    false    217    218    218            �           2604    17385    tesis tesisid    DEFAULT     n   ALTER TABLE ONLY public.tesis ALTER COLUMN tesisid SET DEFAULT nextval('public.tesis_tesisid_seq'::regclass);
 <   ALTER TABLE public.tesis ALTER COLUMN tesisid DROP DEFAULT;
       public               postgres    false    221    222    222            �           2604    25659    voleybolcu voleybolcuid    DEFAULT     �   ALTER TABLE ONLY public.voleybolcu ALTER COLUMN voleybolcuid SET DEFAULT nextval('public.voleybolcu_voleybolcuid_seq'::regclass);
 F   ALTER TABLE public.voleybolcu ALTER COLUMN voleybolcuid DROP DEFAULT;
       public               postgres    false    240    241    241            �          0    17209 	   antrenman 
   TABLE DATA           I   COPY public.antrenman (antrenmanid, bransid, tesisid, tarih) FROM stdin;
    public               postgres    false    236   ��       �          0    16927    antrenor 
   TABLE DATA           E   COPY public.antrenor (antrenorid, adi, takimid, bransid) FROM stdin;
    public               postgres    false    224   +�       �          0    25673    basketbolcu 
   TABLE DATA           Q   COPY public.basketbolcu (basketbolcuid, oyuncuid, pozisyon, takimid) FROM stdin;
    public               postgres    false    243   ��       �          0    16901    brans 
   TABLE DATA           A   COPY public.brans (bransid, adi, takimid, brans_adi) FROM stdin;
    public               postgres    false    220   ��       �          0    16939    doktor 
   TABLE DATA           8   COPY public.doktor (doktorid, adi, bransid) FROM stdin;
    public               postgres    false    226   0�       �          0    25690    esporcu 
   TABLE DATA           H   COPY public.esporcu (esporcuid, oyuncuid, oyunadi, takimid) FROM stdin;
    public               postgres    false    245   ��       �          0    25639    futbolcu 
   TABLE DATA           K   COPY public.futbolcu (futbolcuid, oyuncuid, pozisyon, takimid) FROM stdin;
    public               postgres    false    239   ��       �          0    16980    lig 
   TABLE DATA           9   COPY public.lig (ligid, adi, bransid, sezon) FROM stdin;
    public               postgres    false    232   :�       �          0    17414 	   malideger 
   TABLE DATA           B   COPY public.malideger (bransid, brans_adi, malideger) FROM stdin;
    public               postgres    false    237   ��       �          0    16951 	   oyuncular 
   TABLE DATA           P   COPY public.oyuncular (oyuncuid, adi, takimid, paradegeri, bransid) FROM stdin;
    public               postgres    false    228   �       �          0    17195    personel 
   TABLE DATA           C   COPY public.personel (personelid, adi, gorev, tesisid) FROM stdin;
    public               postgres    false    234   i�       �          0    16968    sponsor 
   TABLE DATA           :   COPY public.sponsor (sponsorid, adi, takimid) FROM stdin;
    public               postgres    false    230   ��       �          0    16894    takim 
   TABLE DATA           >   COPY public.takim (takimid, adi, totalparadegeri) FROM stdin;
    public               postgres    false    218   b�       �          0    16913    tesis 
   TABLE DATA           =   COPY public.tesis (tesisid, adi, sehir, takimid) FROM stdin;
    public               postgres    false    222   ��       �          0    25656 
   voleybolcu 
   TABLE DATA           L   COPY public.voleybolcu (voleybolcuid, oyuncuid, mevki, takimid) FROM stdin;
    public               postgres    false    241   P�       �           0    0    antrenman_antrenmanid_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.antrenman_antrenmanid_seq', 4, true);
          public               postgres    false    235            �           0    0    antrenor_antrenorid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.antrenor_antrenorid_seq', 1, false);
          public               postgres    false    223            �           0    0    basketbolcu_basketbolcuid_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.basketbolcu_basketbolcuid_seq', 1, false);
          public               postgres    false    242            �           0    0    brans_bransid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.brans_bransid_seq', 1, false);
          public               postgres    false    219            �           0    0    doktor_doktorid_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.doktor_doktorid_seq', 1, false);
          public               postgres    false    225            �           0    0    esporcu_esporcuid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.esporcu_esporcuid_seq', 1, false);
          public               postgres    false    244            �           0    0    futbolcu_futbolcuid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.futbolcu_futbolcuid_seq', 1, false);
          public               postgres    false    238            �           0    0    lig_ligid_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lig_ligid_seq', 1, false);
          public               postgres    false    231            �           0    0    oyuncu_oyuncuid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.oyuncu_oyuncuid_seq', 2, true);
          public               postgres    false    227            �           0    0    personel_personelid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.personel_personelid_seq', 4, true);
          public               postgres    false    233            �           0    0    sponsor_sponsorid_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.sponsor_sponsorid_seq', 1, false);
          public               postgres    false    229            �           0    0    takim_takimid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.takim_takimid_seq', 1, false);
          public               postgres    false    217            �           0    0    tesis_tesisid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tesis_tesisid_seq', 1, true);
          public               postgres    false    221            �           0    0    voleybolcu_voleybolcuid_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.voleybolcu_voleybolcuid_seq', 1, false);
          public               postgres    false    240            �           2606    17214    antrenman antrenman_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.antrenman
    ADD CONSTRAINT antrenman_pkey PRIMARY KEY (antrenmanid);
 B   ALTER TABLE ONLY public.antrenman DROP CONSTRAINT antrenman_pkey;
       public                 postgres    false    236            �           2606    16932    antrenor antrenor_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.antrenor
    ADD CONSTRAINT antrenor_pkey PRIMARY KEY (antrenorid);
 @   ALTER TABLE ONLY public.antrenor DROP CONSTRAINT antrenor_pkey;
       public                 postgres    false    224                       2606    25678    basketbolcu basketbolcu_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.basketbolcu
    ADD CONSTRAINT basketbolcu_pkey PRIMARY KEY (basketbolcuid);
 F   ALTER TABLE ONLY public.basketbolcu DROP CONSTRAINT basketbolcu_pkey;
       public                 postgres    false    243            �           2606    16906    brans brans_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.brans
    ADD CONSTRAINT brans_pkey PRIMARY KEY (bransid);
 :   ALTER TABLE ONLY public.brans DROP CONSTRAINT brans_pkey;
       public                 postgres    false    220            �           2606    16944    doktor doktor_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_pkey PRIMARY KEY (doktorid);
 <   ALTER TABLE ONLY public.doktor DROP CONSTRAINT doktor_pkey;
       public                 postgres    false    226                       2606    25695    esporcu esporcu_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.esporcu
    ADD CONSTRAINT esporcu_pkey PRIMARY KEY (esporcuid);
 >   ALTER TABLE ONLY public.esporcu DROP CONSTRAINT esporcu_pkey;
       public                 postgres    false    245            �           2606    25644    futbolcu futbolcu_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.futbolcu
    ADD CONSTRAINT futbolcu_pkey PRIMARY KEY (futbolcuid);
 @   ALTER TABLE ONLY public.futbolcu DROP CONSTRAINT futbolcu_pkey;
       public                 postgres    false    239            �           2606    16987    lig lig_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.lig
    ADD CONSTRAINT lig_pkey PRIMARY KEY (ligid);
 6   ALTER TABLE ONLY public.lig DROP CONSTRAINT lig_pkey;
       public                 postgres    false    232            �           2606    17418    malideger malideger_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.malideger
    ADD CONSTRAINT malideger_pkey PRIMARY KEY (bransid);
 B   ALTER TABLE ONLY public.malideger DROP CONSTRAINT malideger_pkey;
       public                 postgres    false    237            �           2606    16956    oyuncular oyuncu_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.oyuncular
    ADD CONSTRAINT oyuncu_pkey PRIMARY KEY (oyuncuid);
 ?   ALTER TABLE ONLY public.oyuncular DROP CONSTRAINT oyuncu_pkey;
       public                 postgres    false    228            �           2606    17202    personel personel_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personelid);
 @   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_pkey;
       public                 postgres    false    234            �           2606    16973    sponsor sponsor_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.sponsor
    ADD CONSTRAINT sponsor_pkey PRIMARY KEY (sponsorid);
 >   ALTER TABLE ONLY public.sponsor DROP CONSTRAINT sponsor_pkey;
       public                 postgres    false    230            �           2606    16899    takim takim_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.takim
    ADD CONSTRAINT takim_pkey PRIMARY KEY (takimid);
 :   ALTER TABLE ONLY public.takim DROP CONSTRAINT takim_pkey;
       public                 postgres    false    218            �           2606    16920    tesis tesis_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tesis
    ADD CONSTRAINT tesis_pkey PRIMARY KEY (tesisid);
 :   ALTER TABLE ONLY public.tesis DROP CONSTRAINT tesis_pkey;
       public                 postgres    false    222                        2606    25661    voleybolcu voleybolcu_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.voleybolcu
    ADD CONSTRAINT voleybolcu_pkey PRIMARY KEY (voleybolcuid);
 D   ALTER TABLE ONLY public.voleybolcu DROP CONSTRAINT voleybolcu_pkey;
       public                 postgres    false    241            (           2620    25728 #   antrenman trigger_bransid_antrenman    TRIGGER     �   CREATE TRIGGER trigger_bransid_antrenman BEFORE INSERT OR UPDATE ON public.antrenman FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 <   DROP TRIGGER trigger_bransid_antrenman ON public.antrenman;
       public               postgres    false    250    236                       2620    25729 !   antrenor trigger_bransid_antrenor    TRIGGER     �   CREATE TRIGGER trigger_bransid_antrenor BEFORE INSERT OR UPDATE ON public.antrenor FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 :   DROP TRIGGER trigger_bransid_antrenor ON public.antrenor;
       public               postgres    false    250    224                       2620    25730    brans trigger_bransid_brans    TRIGGER     �   CREATE TRIGGER trigger_bransid_brans BEFORE INSERT OR UPDATE ON public.brans FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 4   DROP TRIGGER trigger_bransid_brans ON public.brans;
       public               postgres    false    220    250                       2620    25731    doktor trigger_bransid_doktor    TRIGGER     �   CREATE TRIGGER trigger_bransid_doktor BEFORE INSERT OR UPDATE ON public.doktor FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 6   DROP TRIGGER trigger_bransid_doktor ON public.doktor;
       public               postgres    false    250    226            &           2620    25732    lig trigger_bransid_lig    TRIGGER     �   CREATE TRIGGER trigger_bransid_lig BEFORE INSERT OR UPDATE ON public.lig FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 0   DROP TRIGGER trigger_bransid_lig ON public.lig;
       public               postgres    false    232    250            *           2620    25733 #   malideger trigger_bransid_malideger    TRIGGER     �   CREATE TRIGGER trigger_bransid_malideger BEFORE INSERT OR UPDATE ON public.malideger FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 <   DROP TRIGGER trigger_bransid_malideger ON public.malideger;
       public               postgres    false    250    237                        2620    25734 #   oyuncular trigger_bransid_oyuncular    TRIGGER     �   CREATE TRIGGER trigger_bransid_oyuncular BEFORE INSERT OR UPDATE ON public.oyuncular FOR EACH ROW EXECUTE FUNCTION public.validate_bransid();
 <   DROP TRIGGER trigger_bransid_oyuncular ON public.oyuncular;
       public               postgres    false    228    250            ,           2620    25748 1   basketbolcu trigger_check_id_positive_basketbolcu    TRIGGER     �   CREATE TRIGGER trigger_check_id_positive_basketbolcu BEFORE INSERT OR UPDATE ON public.basketbolcu FOR EACH ROW EXECUTE FUNCTION public.check_id_positive();
 J   DROP TRIGGER trigger_check_id_positive_basketbolcu ON public.basketbolcu;
       public               postgres    false    257    243            !           2620    25738 &   oyuncular trigger_paradegeri_oyuncular    TRIGGER     �   CREATE TRIGGER trigger_paradegeri_oyuncular BEFORE INSERT OR UPDATE ON public.oyuncular FOR EACH ROW EXECUTE FUNCTION public.validate_paradegeri();
 ?   DROP TRIGGER trigger_paradegeri_oyuncular ON public.oyuncular;
       public               postgres    false    228    252            -           2620    25721 '   basketbolcu trigger_takimid_basketbolcu    TRIGGER     �   CREATE TRIGGER trigger_takimid_basketbolcu BEFORE INSERT OR UPDATE ON public.basketbolcu FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 @   DROP TRIGGER trigger_takimid_basketbolcu ON public.basketbolcu;
       public               postgres    false    249    243            .           2620    25722    esporcu trigger_takimid_esporcu    TRIGGER     �   CREATE TRIGGER trigger_takimid_esporcu BEFORE INSERT OR UPDATE ON public.esporcu FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 8   DROP TRIGGER trigger_takimid_esporcu ON public.esporcu;
       public               postgres    false    249    245            +           2620    25723 !   futbolcu trigger_takimid_futbolcu    TRIGGER     �   CREATE TRIGGER trigger_takimid_futbolcu BEFORE INSERT OR UPDATE ON public.futbolcu FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 :   DROP TRIGGER trigger_takimid_futbolcu ON public.futbolcu;
       public               postgres    false    249    239            "           2620    25724 #   oyuncular trigger_takimid_oyuncular    TRIGGER     �   CREATE TRIGGER trigger_takimid_oyuncular BEFORE INSERT OR UPDATE ON public.oyuncular FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 <   DROP TRIGGER trigger_takimid_oyuncular ON public.oyuncular;
       public               postgres    false    249    228            %           2620    25725    sponsor trigger_takimid_sponsor    TRIGGER     �   CREATE TRIGGER trigger_takimid_sponsor BEFORE INSERT OR UPDATE ON public.sponsor FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 8   DROP TRIGGER trigger_takimid_sponsor ON public.sponsor;
       public               postgres    false    230    249                       2620    25720    takim trigger_takimid_takim    TRIGGER     �   CREATE TRIGGER trigger_takimid_takim BEFORE INSERT OR UPDATE ON public.takim FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 4   DROP TRIGGER trigger_takimid_takim ON public.takim;
       public               postgres    false    218    249                       2620    25726    tesis trigger_takimid_tesis    TRIGGER     �   CREATE TRIGGER trigger_takimid_tesis BEFORE INSERT OR UPDATE ON public.tesis FOR EACH ROW EXECUTE FUNCTION public.validate_takimid();
 4   DROP TRIGGER trigger_takimid_tesis ON public.tesis;
       public               postgres    false    222    249            )           2620    25736 !   antrenman trigger_tarih_antrenman    TRIGGER     �   CREATE TRIGGER trigger_tarih_antrenman BEFORE INSERT OR UPDATE ON public.antrenman FOR EACH ROW EXECUTE FUNCTION public.validate_antrenman_tarih();
 :   DROP TRIGGER trigger_tarih_antrenman ON public.antrenman;
       public               postgres    false    236    251                       2620    25740    brans trigger_unique_brans_adi    TRIGGER     �   CREATE TRIGGER trigger_unique_brans_adi BEFORE INSERT OR UPDATE ON public.brans FOR EACH ROW EXECUTE FUNCTION public.validate_unique_brans_adi();
 7   DROP TRIGGER trigger_unique_brans_adi ON public.brans;
       public               postgres    false    253    220                       2620    25742    tesis trigger_unique_tesis    TRIGGER     �   CREATE TRIGGER trigger_unique_tesis BEFORE INSERT OR UPDATE ON public.tesis FOR EACH ROW EXECUTE FUNCTION public.validate_unique_tesis();
 3   DROP TRIGGER trigger_unique_tesis ON public.tesis;
       public               postgres    false    222    254            #           2620    25746 "   oyuncular trigger_update_malideger    TRIGGER     �   CREATE TRIGGER trigger_update_malideger AFTER INSERT OR UPDATE ON public.oyuncular FOR EACH ROW EXECUTE FUNCTION public.update_malideger();
 ;   DROP TRIGGER trigger_update_malideger ON public.oyuncular;
       public               postgres    false    228    256            $           2620    25744 (   oyuncular trigger_update_totalparadegeri    TRIGGER     �   CREATE TRIGGER trigger_update_totalparadegeri AFTER INSERT OR UPDATE ON public.oyuncular FOR EACH ROW EXECUTE FUNCTION public.update_totalparadegeri();
 A   DROP TRIGGER trigger_update_totalparadegeri ON public.oyuncular;
       public               postgres    false    228    255            '           2620    25750    lig validate_sezon_trigger    TRIGGER     �   CREATE TRIGGER validate_sezon_trigger BEFORE INSERT OR UPDATE ON public.lig FOR EACH ROW EXECUTE FUNCTION public.validate_sezon_format();
 3   DROP TRIGGER validate_sezon_trigger ON public.lig;
       public               postgres    false    232    258                       2606    17215     antrenman antrenman_bransid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.antrenman
    ADD CONSTRAINT antrenman_bransid_fkey FOREIGN KEY (bransid) REFERENCES public.brans(bransid);
 J   ALTER TABLE ONLY public.antrenman DROP CONSTRAINT antrenman_bransid_fkey;
       public               postgres    false    220    236    4842                       2606    17220     antrenman antrenman_tesisid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.antrenman
    ADD CONSTRAINT antrenman_tesisid_fkey FOREIGN KEY (tesisid) REFERENCES public.tesis(tesisid);
 J   ALTER TABLE ONLY public.antrenman DROP CONSTRAINT antrenman_tesisid_fkey;
       public               postgres    false    4844    236    222                       2606    16933    antrenor antrenor_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.antrenor
    ADD CONSTRAINT antrenor_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 H   ALTER TABLE ONLY public.antrenor DROP CONSTRAINT antrenor_takimid_fkey;
       public               postgres    false    224    218    4840                       2606    25679 %   basketbolcu basketbolcu_oyuncuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.basketbolcu
    ADD CONSTRAINT basketbolcu_oyuncuid_fkey FOREIGN KEY (oyuncuid) REFERENCES public.oyuncular(oyuncuid) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.basketbolcu DROP CONSTRAINT basketbolcu_oyuncuid_fkey;
       public               postgres    false    4850    228    243                       2606    25684 $   basketbolcu basketbolcu_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.basketbolcu
    ADD CONSTRAINT basketbolcu_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 N   ALTER TABLE ONLY public.basketbolcu DROP CONSTRAINT basketbolcu_takimid_fkey;
       public               postgres    false    243    4840    218                       2606    16907    brans brans_takimid_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.brans
    ADD CONSTRAINT brans_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 B   ALTER TABLE ONLY public.brans DROP CONSTRAINT brans_takimid_fkey;
       public               postgres    false    218    220    4840            	           2606    16945    doktor doktor_bransid_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_bransid_fkey FOREIGN KEY (bransid) REFERENCES public.brans(bransid);
 D   ALTER TABLE ONLY public.doktor DROP CONSTRAINT doktor_bransid_fkey;
       public               postgres    false    226    220    4842                       2606    25696    esporcu esporcu_oyuncuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.esporcu
    ADD CONSTRAINT esporcu_oyuncuid_fkey FOREIGN KEY (oyuncuid) REFERENCES public.oyuncular(oyuncuid) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.esporcu DROP CONSTRAINT esporcu_oyuncuid_fkey;
       public               postgres    false    245    228    4850                       2606    25701    esporcu esporcu_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.esporcu
    ADD CONSTRAINT esporcu_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 F   ALTER TABLE ONLY public.esporcu DROP CONSTRAINT esporcu_takimid_fkey;
       public               postgres    false    4840    218    245                       2606    17321    antrenor fk_antrenor_bransid    FK CONSTRAINT     �   ALTER TABLE ONLY public.antrenor
    ADD CONSTRAINT fk_antrenor_bransid FOREIGN KEY (bransid) REFERENCES public.brans(bransid);
 F   ALTER TABLE ONLY public.antrenor DROP CONSTRAINT fk_antrenor_bransid;
       public               postgres    false    220    224    4842                       2606    25645    futbolcu futbolcu_oyuncuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.futbolcu
    ADD CONSTRAINT futbolcu_oyuncuid_fkey FOREIGN KEY (oyuncuid) REFERENCES public.oyuncular(oyuncuid) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.futbolcu DROP CONSTRAINT futbolcu_oyuncuid_fkey;
       public               postgres    false    239    4850    228                       2606    25650    futbolcu futbolcu_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.futbolcu
    ADD CONSTRAINT futbolcu_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 H   ALTER TABLE ONLY public.futbolcu DROP CONSTRAINT futbolcu_takimid_fkey;
       public               postgres    false    4840    239    218                       2606    16988    lig lig_bransid_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.lig
    ADD CONSTRAINT lig_bransid_fkey FOREIGN KEY (bransid) REFERENCES public.brans(bransid);
 >   ALTER TABLE ONLY public.lig DROP CONSTRAINT lig_bransid_fkey;
       public               postgres    false    232    4842    220            
           2606    16962    oyuncular oyuncu_bransid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyuncular
    ADD CONSTRAINT oyuncu_bransid_fkey FOREIGN KEY (bransid) REFERENCES public.brans(bransid);
 G   ALTER TABLE ONLY public.oyuncular DROP CONSTRAINT oyuncu_bransid_fkey;
       public               postgres    false    4842    220    228                       2606    16957    oyuncular oyuncu_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyuncular
    ADD CONSTRAINT oyuncu_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 G   ALTER TABLE ONLY public.oyuncular DROP CONSTRAINT oyuncu_takimid_fkey;
       public               postgres    false    4840    228    218                       2606    17203    personel personel_tesisid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_tesisid_fkey FOREIGN KEY (tesisid) REFERENCES public.tesis(tesisid);
 H   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_tesisid_fkey;
       public               postgres    false    4844    222    234                       2606    16974    sponsor sponsor_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sponsor
    ADD CONSTRAINT sponsor_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 F   ALTER TABLE ONLY public.sponsor DROP CONSTRAINT sponsor_takimid_fkey;
       public               postgres    false    230    218    4840                       2606    16921    tesis tesis_takimid_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.tesis
    ADD CONSTRAINT tesis_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 B   ALTER TABLE ONLY public.tesis DROP CONSTRAINT tesis_takimid_fkey;
       public               postgres    false    4840    218    222                       2606    25662 #   voleybolcu voleybolcu_oyuncuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.voleybolcu
    ADD CONSTRAINT voleybolcu_oyuncuid_fkey FOREIGN KEY (oyuncuid) REFERENCES public.oyuncular(oyuncuid) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.voleybolcu DROP CONSTRAINT voleybolcu_oyuncuid_fkey;
       public               postgres    false    4850    228    241                       2606    25667 "   voleybolcu voleybolcu_takimid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.voleybolcu
    ADD CONSTRAINT voleybolcu_takimid_fkey FOREIGN KEY (takimid) REFERENCES public.takim(takimid);
 L   ALTER TABLE ONLY public.voleybolcu DROP CONSTRAINT voleybolcu_takimid_fkey;
       public               postgres    false    218    241    4840            �   7   x�Eȱ  �:�%(��6�?�@�������br�����cc��(�q��z6      �   \   x�3���N�Sp*-*��4�4�2�*K�J��f��ei�qs:���eVe&*�$*g�%ō�L8#�3��r�B&\1z\\\ �{      �   =   x�3�4�t/M,J�4�2�4�t�/*K-r�9�92��AlNΣ�JKo+R�)����� ��j      �   <   x�3�t+-I���4�2��8���S��p6�1gX~Nj%D��2�t-.�/
�i�=... h!{      �   R   x�3�L�K-R8�!/9�Ӑˈ�1#7�D�)��(1�ӈ˘ӷ��$1-Q�����4�Ә˄3*5;S����{�8M�b���� tb5      �   .   x�3�44�K��/J�+�4�2�44A�s�"�M8͐�1z\\\ r�}      �   Z   x�3�4��N�IM��4�2�4�N<2_�)5�5�4��/*ITN�H�M8M8���RK�SNS�l�F3NCsϜ�Ђ3���1F��� w��      �   _   x�3�>�� �H�'3�Ӑ����XH�pq:%g��$��( �dr!�1�tMḰ�#ɘp��(��S��Y����Y��yd~&�	XW� ��"w      �   N   x�3���I�L���4422 =.N���"NK��!�[i	H��9P���B�ˈ�)�8;,ndRjR���� �S�      �   R  x�U��n�0E����8/�Z����JR7���đ�8�ˮٰ���j��\o,�x�3���+�2����+IН^ #!�b�F:��ֲ��"��5}��⢫e��c��Q}�P�����	,j��L4B�t]ɛ��!Ia�����K�ĭH=ܷ������R(:�O����e �(�)Kga���w6��������Ucyt�aL�tZ5�,�1�p��k��,�{�KǛ߽���`!����Q�|w�t0&,vYcM���(qw����*۞O���t�hc�ɻp�H
Kl��agG���+S_�s�҇�H\ی�讻$�n+l (Eq~	m��B� Lǎ�      �   {   x����0���)<R~���"�"�D�	N�ctvc`fp�b��֋����V�Հ��K̬�KRFG=f~�ƺ&)�%��� [~_6Ǉ�8�K:v�@#ά����(�I\���'"��(}      �   ^   x�3�9��([!$5'5;?�Ӑˈ32���F�ԔL ߘ�/3;�0����+.I-RH:�1'�������"��)gnbeJ~^~��L	��qqq �      �   '   x�3�tO�I,I,N,J��41�44044ճ0����� ���      �   �   x�e�;�0��)� )| R��(��h6d%,;6Zۅ9i� 9��@�o�L;�6��ǃMT���D�b`Kvľ�e��#&�mvP�h��c-��oAP�>�&��}	{r�(�L�Sp\�ྊ&���묠��n�b�n���L���R�+9����>C
��D�s����S	      �   L   x�3���M<���"NC.#NCN���D��Ҽ�R��1��!g@b1P����Ă�Ī#��&��FPq /F��� ��     