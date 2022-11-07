-- Chargement de données
arbres_bruts = LOAD '/apps/arbres.csv'  USING PigStorage(';') AS (geopoint:tuple(lat:double,lon:double),arron:long,genre:chararray, espece:chararray,famille:chararray,annee:long,hauteur:double,circonf:double, adresse:chararray,commun:chararray,variete:chararray,id:long,nomev:chararray);
DESCRIBE arbres_bruts;
DUMP arbres_bruts;
-- Filtrage
arbres = FILTER arbres_bruts BY geopoint IS NOT NULL;
resultat = FILTER arbres BY geopoint.lon > 2.45;
-- Classement
arbres_avec_annee = FILTER arbres BY annee IS NOT NULL;
arbres_classes = ORDER arbres_avec_annee BY annee ASC;
-- Premiers n-uplets
vieux_arbres = LIMIT arbres_classes 5;
rangs_arbres = RANK arbres_avec_annee BY annee ASC;
DESCRIBE rangs_arbres;
vieux_arbres2 = FILTER rangs_arbres BY rank_arbres_avec_annee <= 5L;
-- Projection et calculs
genres_ages = FOREACH arbres GENERATE genre, 2022L-annee;
genres_ages = FOREACH arbres GENERATE $2, 2022L-$5;
genres_ages = FOREACH arbres GENERATE genre, 2022L-annee AS age;
DESCRIBE genres_ages;
vieux_arbres2_ok = FOREACH vieux_arbres2 GENERATE geopoint ..;
-- Éléments distincts
annees_toutes = FOREACH arbres_avec_annee GENERATE annee;
annees = DISTINCT annees_toutes;
-- Groupement
genres_ages_connus = FILTER genres_ages BY age IS NOT NULL;
DESCRIBE genres_ages_connus;
ages_par_genre = GROUP genres_ages_connus BY genre;
DESCRIBE ages_par_genre;

ages = FOREACH genres_ages_connus GENERATE age;
DESCRIBE ages;
groupe_ages = GROUP ages ALL;
DESCRIBE groupe_ages;
-- Parcours d’un groupement
resultat = FOREACH ages_par_genre GENERATE group, genres_ages_connus.age;
-- Agregation

nombre = FOREACH groupe_ages GENERATE COUNT(ages.age);
age_moyen = FOREACH groupe_ages GENERATE AVG(ages.age);
age_maximal = FOREACH groupe_ages GENERATE MAX(ages.age);

age_maximal = FOREACH ages_par_genre GENERATE group, MAX(genres_ages_connus.age);
-- Dégroupement
plat = FOREACH ages_par_genre GENERATE FLATTEN(genres_ages_connus);

-- Imbrications
tmp = FOREACH ages_par_genre {
vieux = FILTER genres_ages_connus BY age > 150L;
GENERATE group AS genre, COUNT(vieux) AS nombre;
}
resultat = FILTER tmp BY nombre>=2L;
